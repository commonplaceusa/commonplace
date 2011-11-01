desc "Will sanitize the current database (removes avatar_file_name, ..)"
task "db:sanitize" => :environment do
  User.update_all("avatar_file_name = null")
end
