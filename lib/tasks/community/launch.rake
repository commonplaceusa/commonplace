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
        Rake::Task["community:seed"].invoke(slug)
        Rake.application.invoke_task("community:fix_group_images[#{args[:slug]}]")
      rescue => e
        puts "FAILED"
        puts e.message
        raise ActiveRecord::Rollback
      end
    end
  end

  task :seed, [:slug] => :environment do |t, args|
    require 'open-uri'
    community = Community.find_by_slug(args[:slug])
    if community.nil?
      raise "Could not find community with slug #{args[:slug]}"
    end
    slug = args[:slug]

    pass_salt = ENV['COMMONPLACE_ADMIN_PASSWORD_SALT']
    password = "commonplace#{pass_salt}"

    # Find the original users. Used to "borrow" avatar images
    original_max = User.find_by_email_and_community_id("max@ourcommonplace.com", Community.find_by_slug("Somerville").id)
    original_pete = Community.find_by_slug("FallsChurch").users.find_by_first_name_and_last_name("Peter", "Davis")
    original_ricky = User.find_by_email("rickyporco+somerville@gmail.com")

    max = User.create!(
      email: "mnovendstern+#{slug}@gmail.com",
      password: password,
      password_confirmation: password,
      first_name: "Max",
      last_name: "Novendstern",
      about: "Hi, I'm Max Novendstern. I'm a community organizer here at OurCommonPlace #{community.name}!",
      admin: true,
      address: "125 Western Ave",
      referral_source: "Seeded data",
      community_id: community.id
    )
    max.avatar = open(original_max.avatar_url)
    max.avatar.instance_write(:filename, original_max.avatar_file_name)
    max.save!

    pete = User.create!(
      email: "petehappens+#{slug}@gmail.com",
      password: password,
      password_confirmation: password,
      first_name: "Pete",
      last_name: "Davis",
      about: "Hey neighbors! I'm Pete Davis, one of the directors of OurCommonPlace #{community.name}. Let me know if you ever have any questions!",
      admin: true,
      address: "125 Western Ave",
      referral_source: "Seeded data",
      community_id: community.id
    )
    pete.avatar = open(original_pete.avatar_url)
    pete.avatar.instance_write(:filename, original_pete.avatar_file_name)
    pete.save!

    ricky = User.create!(
      email: "rickyporco+#{slug}@gmail.com",
      password: password,
      password_confirmation: password,
      first_name: "Ricky",
      last_name: "Porco",
      about: "I'm Ricky Porco, a recent college grad and one of the head community organizers at OurCommonPlace #{community.name}. I love helping, so reach out if you need anything!",
      admin: true,
      address: "125 Western Ave",
      referral_source: "Seeded data",
      community_id: community.id
    )
    ricky.avatar = open(original_ricky.avatar_url)
    ricky.avatar.instance_write(:filename, original_ricky.avatar_file_name)
    ricky.save!

    post = Post.create!(
      body: "Have you ever needed a local service (like a babysitter, or someone to mow your lawn), or used good (like a ladder to borrow), or wanted to meet someone in town (and host a book club or block party)? Use OurCommonPlace #{community.name} to ask your neighbors!",
      user_id: pete.id,
      subject: "Hi Neighbors!",
      community_id: community.id,
      category: "offers"
    )
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
