namespace :community do
  task :launch, [:name, :slug] => :environment do |t, args|
    ActiveRecord::Base.transaction do
      begin
        new_community = Community.create!(
          name: args[:name],
          slug: args[:slug]
        )
        new_neighborhood = Neighborhood.create!(
          name: args[:name],
          community: new_community
        )
        # new_community.neighborhood = new_neighborhood
        # new_community.save!
        new_community.add_default_groups!
        Rake.application.invoke_task("community:fix_group_images[#{args[:slug]}]")
      rescue => e
        puts "FAILED"
        puts e.message
        raise ActiveRecord::Rollback
      end
    end
  end

  task :fix_group_images, [:slug] => :environment do |t, args|
    community = Community.find_by_slug(args[:slug])
    community.add_default_groups! if community.groups.empty?
    community.groups.each do |group|
      # All slugs should be lowercase
      new_group = I18n.t("default_groups").select { |g| g.name == group.name }.first
      next unless new_group.present?
      group.slug = new_group.slug
      group.avatar_url = "https://s3.amazonaws.com/commonplace-avatars-production/groups/#{group.slug}.png"
      group.save!
    end
  end
end
