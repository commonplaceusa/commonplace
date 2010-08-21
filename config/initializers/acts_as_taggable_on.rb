module ActsAsTaggableOn::Taggable
  module Core

    module InstanceMethods
      
    end
  end
end
  
module ActsAsTaggableOn::Taggable
  module Related
    module InstanceMethods
      
      def related_of_class(klass, options = {})
        tags_to_find = base_tags.map { |t| t.aliases.map(&:name) }.flatten

        exclude_self = "#{klass.table_name}.id != #{id} AND" if self.class == klass

group_columns = "#{klass.table_name}.#{klass.primary_key}"

        klass.scoped({ :select     => "#{klass.table_name}.*, COUNT(#{ActsAsTaggableOn::Tag.table_name}.id) AS count",
                       :from       => "#{klass.table_name}, #{ActsAsTaggableOn::Tag.table_name}, #{ActsAsTaggableOn::Tagging.table_name}",
                       :conditions => ["#{exclude_self} #{klass.table_name}.id = #{ActsAsTaggableOn::Tagging.table_name}.taggable_id AND #{ActsAsTaggableOn::Tagging.table_name}.taggable_type = '#{klass.to_s}' AND #{ActsAsTaggableOn::Tagging.table_name}.tag_id = #{ActsAsTaggableOn::Tag.table_name}.id AND #{ActsAsTaggableOn::Tag.table_name}.name IN (?)", tags_to_find],
                       :group      => group_columns,
                       :order      => "count DESC" }.update(options))
      end

    end
  end
end


class ActsAsTaggableOn::Tag < ActiveRecord::Base
  belongs_to :canonical_tag, :class_name => 'ActsAsTaggableOn::Tag'
  has_many :aliases, :foreign_key => 'canonical_tag_id', :class_name => 'ActsAsTaggableOn::Tag', :dependent => :nullify, :primary_key => :canonical_tag_id
  
  after_create :set_canonical_tag_id
  
  def canonical?
    canonical_tag_id == id
  end
  
  protected

  def set_canonical_tag_id
    unless self.canonical_tag_id
      self.canonical_tag_id = self.id
      self.save
    end
  end
  
end
