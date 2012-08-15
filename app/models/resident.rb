require 'rubygems'
require 'json'
require 'digest/md5'
require 'net/http'
require 'uri'
#require 'pismo'

class Resident < ActiveRecord::Base
  serialize :metadata, Hash
  serialize :logs, Array
  serialize :old_stories, Array

  acts_as_taggable
  acts_as_taggable_on :sector_tags, :type_tags, :input_method, :PFO_status, :organizer

  belongs_to :community

  belongs_to :user
  belongs_to :street_address

  has_many :flags

  after_create :manual_add#, :find_story

  def self.find_by_full_name(full_name)
    name = full_name.split(" ")
    r = where("residents.last_name ILIKE ? AND residents.first_name ILIKE ?", name.last, name.first)

    return r if !r.empty?

    nil
  end

  def on_commonplace?
    self.user_id?
  end

  def street_address?
    self.street_address_id?
  end

  def friends_on_commonplace?
    [false, true].sample
  end

  def in_commonplace_organization?
    [false, true].sample
  end

  def manually_added?
    self.metadata[:manually_added] ||= false
  end

  def full_name
    [first_name, last_name].select(&:present?).join(" ")
  end

  def name
    full_name
  end

  def add_log(date, text, tags)
    self.add_tags(tags)
    self.logs << [date, ": ", text].join
    self.save
  end

  def avatar_url
    begin
      self.user.avatar_url
    rescue
      "https://s3.amazonaws.com/commonplace-avatars-production/missing.png"
    end
  end

  def tags
    tags = []
    tags += self.metadata[:tags] if self.metadata[:tags]
=begin
    tags << "registered" if self.user.present?
    tags << "email" if self.email?
    tags << "address" if self.address?
=end
    tags
  end

  def manualtags
    tags = self.flags.map &:name

    tags
  end

  def actionstags
    actionstags=[]
    if self.on_commonplace?
      u = self.user
      if !u.nil?
        actionstags += u.action_tags
      end
    end
=begin
    if self.stories_count>0
      actionstags << "story"
    end
=end
    actionstags
  end

  def interest_list
    if self.on_commonplace?
      u = self.user
      if !u.nil?
        u.interest_list
      else
        []
      end
    else
      []
    end
  end

  # Created via Organizer App
  def manual_add
    self.metadata[:todos] ||= []
    if self.manually_added
      # self.add_tags("nominate")
    end
  end

  def todos
    todos = []
    todos |= self.metadata[:todos] if self.metadata[:todos]
    todos
  end

  def registered
    self.metadata[:tags] ||= []
    self.metadata[:tags] << "registered"
    self.community.add_resident_tags(Array("registered"))
    self.save
  end

  # Creates tags associated with the resident
  #
  # Returns a list of todos
  def add_flags(flags)
    metadata[:remove] ||= []
    metadata[:add] ||= []

    flags.each do |flag|
      if rule = Flag.get_rule(flag)
        if !self.flags.find_by_name(flag)
          f = self.flags.create(:name => flag)
          if replace = f.replace_flag
            remove_tag(replace)
          end
          metadata[:remove] |= rule[0]
          metadata[:add] |= rule[1]
        end
      end
    end

    [metadata[:remove], metadata[:add]]
  end

  def remove_flag(flag)
    rules = Flag.get_rule(flag)
    todos = rules[0] | rules[1]

    # For each todo associated with the given flag...
    todos.each do |todo|
      tags = Flag.get_todo(todo)
      un_cant = tags[1]
      un_should = tags[2]
      change = true

      # Check if Resident has other "can't display" tags for this todo
      un_cant.each do |tag|
        if metadata[:tags].include?(tag)
          change = false
          break
        end
      end

      # If it doesn't, then remove todo from the "can't display" list
      if change
        metadata[:remove] -= Array(todo)
      end

      change = true

      # Check if Resident has other "should display" tags for this todo
      un_should.each do |tag|
        if metadata[:tags].include?(tag)
          change = false
          break
        end
      end

      # If it doesn't, then remove todo from the "should display" list
      if change
        metadata[:add] -= Array(todo)
      end
    end
  end

  def add_tags(tag_or_tags)
    tags = Array(tag_or_tags)

    # Edit todo list
    self.metadata[:todos] ||= []
    todos ||= add_flags(tags)
    self.metadata[:todos] |= todos[1]
    self.metadata[:todos] -= todos[0]

    # Add to tag list
    self.metadata[:tags] ||= []
    self.metadata[:tags] |= tags
    self.community.add_resident_tags(tags)
    self.save
  end

  def remove_tag(tag)
    if !metadata[:tags].include?(tag)
      return
    end

    tags = Array(tag)
    self.metadata[:tags] ||= []
    self.metadata[:tags] -= tags

    remove_flag(tag)
    self.save
  end

  def add_sector_tags(tags)
    sectortags = tags.split(',')
    self.sector_tags ||= []
    self.sector_tags |= sectortags
    #self.community.add_resident_tags(tags)
    self.save
  end


  def add_type_tags(tag_or_tags)
    typetags = Array(tag_or_tags)
    self.type_tags ||= []
    self.type_tags |= typetags
    #self.community.add_resident_tags(tags)
    self.save
  end

  searchable do
    integer :community_id
    string :todos, :multiple => true
    string :tags, :multiple => true
    string :sector_tags, :multiple => true
    string :type_tags, :multiple => true
    string :first_name
    string :last_name
    text :full_name
  end

  # Correlates Resident with existing Users
  # and StreetAddresses [if possible]
  #
  # Since Users are always associated with a Resident,
  # this function simply adds tags to the existing
  # Resident file if a correlation exists and
  # does nothing otherwise, if given only an e-mail
  #
  # @return boolean, depending on whether a correlation was found or not
  # If true, destroy this [redundant] Resident file
  def correlate
    if self.address?
      matched_street = User.where("address ILIKE ? AND last_name ILIKE ?", self.address)

      if matched_street.count > 1
        matched = matched_street.select { |resident| resident.first_name == self.first_name }

        if matched.count > 1
          # Well, what are the odds? =(
        end

        if matched.count == 1
          # matched.first.add_tags(self.tags)
          return true
        else
          # No match, but should match with a StreetAddress file
          matched_addr = StreetAddress.where("address ILIKE ?","%#{self.address}%")

          if matched_addr.count == 1
            street = matched_addr.first
            if street.unreliable name == "#{self.first_name} #{self.last_name}"
              # add tags
              return true
            end

            # Not the property owner
            self.street_address = street
          end

          return false
        end
      end
    elsif self.email?
      matched_email = User.where("email ILIKE ? AND last_name ILIKE ?", self.email, self.last_name)

      if matched_email.count > 1
        # We have a problem; No two Users should have the same e-mail D=
      end

      # Add whatever was inputted to the existing Residents file
      if matched_email.count == 1
        # matched_email.first.add_tags(self.tags)
        return true
      else
        return false
      end
    else
      # A name isn't really much to work with.
      # Don't let this happen in a higher level function?

      # Until then, destroy as a contingency plan
      return true
    end
  end

  def find_story
    stories=self.community.stories.order("created_at DESC")
    if stories.size>0
      new_last=stories[0].id
      new_stories=[]
      time=[]
      stories.each do |story|
        if story.id!=self.last_examined_story
          if story.content?
            if story.content.include?(self.first_name+" "+self.last_name)
              puts story.title
              new_stories << {"story_url"=>story.url,"title"=>story.title,"summary"=>story.summary}
              time << story.created_at
            end
          end
        else
          break
        end
      end

      self.stories_count=time.size+self.stories_count
      self.old_stories=self.old_stories+new_stories
      #if self.stories_count>0 && self.
      self.last_story_time=time[0] unless time.size==0
      self.last_examined_story=new_last
      self.save
    end

    self.old_stories
  end
end
