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

  has_many :flags, :dependent => :destroy

  after_create :manual_add#, :find_story

  def self.find_by_full_name(full_name)
    name = full_name.split(" ")
    r = where("residents.last_name ILIKE ? AND residents.first_name ILIKE ?", name.last, name.first)

    return r
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

    if self.user.present?
      tags |= Array("Joined CP")

      r = self.user.referral_source
      tags << "Referral: " + r if !r.nil?
    end
=begin
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
      self.add_tags("Status: Not Yet On Civic Heroes Track")
      self.add_tags("Status: Not Yet On Supporter Track")
      self.add_tags("Type: Leader On-Boarding Process")
      self.add_tags("Type: Not Yet PFO/Non-PFO")
    end
  end

  def todos
    todos = []
    todos |= self.metadata[:todos] if self.metadata[:todos]
    todos
  end

  def registered
    self.metadata[:tags] ||= []
    self.metadata[:tags] |= "Joined CP"
    self.community.add_resident_tags(Array("Joined CP"))
    self.save
  end

  # Creates tags associated with the resident
  #
  # Returns a list of todos
  def add_flags(flags)
    metadata[:remove] ||= []
    metadata[:add] ||= []

    flags.each do |flag|
      ignore = Flag.ignore_flag(flag)
      if !ignore.nil? && metadata[:tags].include?(ignore)
        next
      end
      if !self.flags.find_by_name(flag)
        f = self.flags.create(:name => flag)
        if replace = f.replace_flag
          remove_tag(replace)
        end
        if rule = Flag.get_rule(flag)
          metadata[:remove] |= rule[0]
          metadata[:add] |= rule[1]
        end
      else
        if rule = Flag.get_rule(flag)
          metadata[:remove] |= rule[0]
          metadata[:add] |= rule[1]
        end
      end
    end

    [metadata[:remove], metadata[:add]]
  end

  def remove_flag(flag)
    rules = Flag.get_rule(flag)

    if rules.nil?
      return
    end

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

    self.metadata[:todos] ||= []
    self.metadata[:tags] ||= []

    # Don't add tags that have replacements
    tags.each do |tag|
      ignore = Flag.ignore_flag(tag)
      tags.delete(tag) if !ignore.nil? && metadata[:tags].include?(ignore)
    end

    # Edit todo list
    todos ||= add_flags(tags)
    self.metadata[:todos] |= todos[1]
    self.metadata[:todos] -= todos[0]

    # Add to tag list
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

  # If a correlation is found, then stuff has to be merged into one file
  def merge_into(r)
    if !self.metadata[:add].nil?
      if !r.metadata[:add].nil?
        r.metadata[:add] |= self.metadata[:add]
      else
        r.metadata[:add] = self.metadata[:add]
      end
    end

    if !self.metadata[:remove].nil?
      if !r.metadata[:remove].nil?
        r.metadata[:remove] |= self.metadata[:remove]
      else
        r.metadata[:remove] = self.metadata[:remove]
      end
    end

    if !r.metadata[:todo].nil?
      r.metadata[:todo] |= r.metadata[:add] - r.metadata[:remove]
    else
      r.metadata[:todo] = r.metadata[:add] - r.metadata[:remove]
    end

    if !r.metadata[:tags].nil?
      r.metadata[:tags] |= self.metadata[:tags]
    else
      r.metadata[:tags] = self.metadata[:tags]
    end

    self.metadata[:tags].each do |tag|
      r.add_tags(tag)
    end

    r.sector_tag_list |= self.sector_tag_list
    r.type_tag_list |= self.type_tag_list
    r.input_method_list |= self.input_method_list
    r.PFO_statu_list |= self.PFO_statu_list
    r.organizer_list |= self.organizer_list

    r.email = self.email if r.email.nil? && !self.email.nil? && !self.email.empty?
    r.phone = self.phone if r.phone.nil? && !self.phone.nil? && !self.phone.empty?
    r.organization = self.organization if r.organization.nil? && !self.organization.nil? && !self.organization.empty?
    r.position = self.position if r.position.nil? && !self.position.nil? && !self.position.empty?
    r.address = self.address if r.address.nil? && !self.address.nil? && !self.address.empty?

    if !self.notes.nil? && !self.notes.empty?
      if r.notes.nil?
        r.notes = self.notes
      else
        new_notes = r.notes << ", " << self.notes
        r.notes = nil
        r.save
        r.notes = new_notes
      end
    end

    r.manually_added ||= self.manually_added
    r.save
  end

  # Correlates Resident with existing Residents
  # and StreetAddresses [if possible]
  def correlate
    correlated = false
    r = nil

    # Correlate by address
    if self.address?
      matched_street = self.community.residents.where("residents.id != ? AND address ILIKE ? AND last_name ILIKE ?", self.id, self.address, self.last_name)

      if matched_street.count > 0
        matched = matched_street.select { |resident| resident.first_name == self.first_name }

        if matched.count > 1
          # Well, what are the odds? =(
        end

        if matched.count == 1
          r = matched.first

          self.merge_into(r)
          correlated = true

        else
          # No match, but might match with a StreetAddress file
          matched_addr = self.community.street_addresses.where("address ILIKE ?","%#{self.address}%")

          if matched_addr.count == 1
            street = matched_addr.first

            self.street_address = street
          end
        end
      end
    end

    # Correlate by email
    if self.email?
      matched_email = self.community.residents.where("residents.id != ? AND email ILIKE ?", self.id, self.email)

      # If this happens, then at least one of the files must have been
      # inputted/modified in the organizer app
      if matched_email.count > 1
      end

      # Add whatever was inputted to the existing Residents file
      if matched_email.count == 1
        r = matched_email.first

        self.merge_into(r)

        correlated = true
      end
    end

    # If there is neither an address nor an email, then there's a good chance of
    # correlating with the wrong file...so don't correlate
    if correlated
      self.destroy
    end

    r
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
