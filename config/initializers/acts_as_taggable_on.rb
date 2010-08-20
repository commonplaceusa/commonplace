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
        tags_to_find = base_tags.collect { |t| t.name }

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
