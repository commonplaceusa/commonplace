require 'area'

def zip_code_for_community(locale, state)
  "#{locale.titleize}, #{state}".to_zip.try(:first)
end

namespace :community do
  task :launch, [:slug, :state] => :environment do |t, args|
    ActiveRecord::Base.transaction do
      begin
        new_community = Community.create!(
          name: args[:slug].titleize,
          slug: args[:slug],
          zip_code: zip_code_for_community(args[:slug], args[:state].upcase),
          state: args[:state].upcase
        )
        new_neighborhood = Neighborhood.create!(
          name: args[:slug].titleize,
          community: new_community
        )
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

  task :launch_list, [:names, :state] => :environment do |t, args|
    require 'area'
    communities = args[:names].split ";"
    state = args[:state]
    communities.each do |slug|
      puts "Creating community for #{slug}"
      # Look up the zip code given the state
      zip_code = zip_code_for_community(slug, state)
      Rake::Task["community:launch"].invoke(slug, slug, zip_code.to_s, state)
      Rake::Task["community:launch"].reenable
    end
  end
end
