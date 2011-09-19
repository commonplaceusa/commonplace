class MoveGroupAvatarsToAssets < ActiveRecord::Migration
  def up
    Group.find_each do |group|
      old_file_name = group.avatar_file_name
      if old_file_name.match(%r{^/images/})
        group.avatar_file_name = old_file_name.gsub(%r{^/images/}, "/assets/")
        group.save(:validate => false)
      end
    end
  end

  def down
    Group.find_each do |group|
      old_file_name = group.avatar_file_name
      if old_file_name.match(%r{^/assets/})
        group.avatar_file_name = old_file_name.gsub(%r{^/assets/}, "/images/")
        group.save(:validate => false)
      end
    end

  end
end
