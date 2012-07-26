class UserErrors

  def initialize(user)
    @user = user
  end

  def to_json
    @user.valid?
    {
      "success" => "false",
      "email" => @user.errors["email"],
      "full_name" => @user.errors["full_name"],
      "address" => @user.errors["address"],
      "password" => @user.errors["encrypted_password"],
      "facebook" => @user.errors["facebook_uid"],
      "referral_source" => @user.errors["referral_source"]
    }.to_json
  end

end
