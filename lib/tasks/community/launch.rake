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
        Rake.application.invoke_task("community:fix_group_images[#{args[:slug]}]")
      rescue => e
        puts "FAILED"
        puts e.message
        raise ActiveRecord::Rollback
      end
    end
  end

  task :fix_group_images, [:slug] => :environment do |t, args|

  end
end
