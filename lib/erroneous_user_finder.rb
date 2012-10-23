class ErroneousUserFinder
  def invalid_users(reload = false)
    @invalid_users = User.all.select(&:invalid?) if reload or !@invalid_users.present?
    @invalid_users
  end

  def consider_destroying(users)
    @destruction_candidates = [] unless @destruction_candidates.present?
    Array(users).each { |u| @destruction_candidates << u.id }
  end

  def destruction_candidates
    @destruction_candidates
  end

  def perform!
    invalid_users.each do |user|
      # Identify error type

      error_message = user.errors.messages.first
      error_type = "#{error_message[0].to_s} #{error_message[1][0]}"
      if error_type == "email has already been taken"
        duplicate_users = User.find_all_by_email(user.email)
        duplicate_users.sort_by do |u|
          u.posted_content.count + u.messages.count + u.replies.count
        end
        consider_destroying(duplicate_users - Array(duplicate_users.last))
      elsif error_type == "encrypted_password can't be blank"
        consider_destroying(user) unless user.facebook_uid.present? or user.posted_content.count > 1
      else
        puts "Unhandled error: #{error_type}"
      end
    end

    puts "The following #{invalid_users.count} users started invalid: #{invalid_users.map(&:id)}"
    puts "Considering destroying #{destruction_candidates.count}: #{destruction_candidates}"
    puts "Remaining #{(invalid_users.map(&:id) - destruction_candidates).count} users: #{invalid_users.map(&:id) - destruction_candidates}"

    puts "=====================DESTROYING========================"
    destruction_candidates.each do |candidate_id|
      puts "Destroying #{candidate_id}"
      begin
        User.find(candidate_id).destroy
      rescue
        puts "FAILED"
      end
    end
  end
end
