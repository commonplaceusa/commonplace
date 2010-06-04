class Account

  include Validatable

  attr_accessor :user
  attr_accessor :code
  attr_accessor :privacy_policy
  
  def first_name
    @user.first_name
  end
  def last_name
    @user.last_name
  end
  def email
    @user.email
  end
  def address
    @user.address
  end
  def password
    @user.password
  end
  def password_confirmation
    @user.password_confirmation
  end
  

  validates_true_for :code, :logic => lambda { CONFIG["registration_code"] == code }, :message => "Sorry, we didn't recognize this registration code."
  validates_acceptance_of :privacy_policy, :if => lambda {@privacy_policy != "1"}, 
    :message => "Please read and accept our privacy policy!"
  include_errors_from :user

  def initialize(params = {})
    if params
      @code = params[:code]
      @privacy_policy = params[:privacy_policy]
      @user = User.new(params.except(:code,:privacy_policy,:password,:password_confirmation))
      @user.password = params[:password]
      @user.password_confirmation = params[:password_confirmation]
    else
      @user = User.new
    end
  end
  
  
  def save
    if valid?
      @user.save
    end
  end

  def new_record?
    if @user
      @user.new_record?
    else
      true
    end
  end
      
  def self.human_name
    'registration'
  end

  
end
