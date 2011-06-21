
desc "Will generate and upload an email header image for each community"
task :upload_email_header => :environment do
  Community.find_each do |community| 
    EmailHeader.new(community).upload!
  end    
end
