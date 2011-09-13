require "#{Rails.root}/db/migrate/20110303072220_dont_use_acts_as_taggable_on_for_user_tag_fields.rb"

class UseActsAsTaggableOnForUserTagFields < ActiveRecord::Migration
  def self.up
    DontUseActsAsTaggableOnForUserTagFields.down
  end

  def self.down
    DontUseActsAsTaggableOnForUserTagFields.up
  end
end
