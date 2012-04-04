# RailsAdmin config file. Generated on April 04, 2012 13:27
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|

  # If your default_local is different from :en, uncomment the following 2 lines and set your default locale here:
  # require 'i18n'
  # I18n.default_locale = :de

  config.current_user_method { current_admin_user } # auto-generated

  # If you want to track changes on your models:
  # config.audit_with :history, AdminUser

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, AdminUser

  # Set the admin name here (optional second array element will appear in a beautiful RailsAdmin red ©)
  config.main_app_name = ['Commonplace', 'Admin']
  # or for a dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }


  #  ==> Global show view settings
  # Display empty fields in show views
  # config.compact_show_view = false

  #  ==> Global list view settings
  # Number of default rows per-page:
  # config.default_items_per_page = 20

  #  ==> Included models
  # Add all excluded models here:
  # config.excluded_models = [AdminUser, Announcement, AnnouncementCrossPosting, Attendance, Community, Essay, Event, EventCrossPosting, Feed, FeedOwner, Group, GroupPost, HalfUser, Invite, Membership, Message, Met, OrganizerDataPoint, Referral, Reply, Resident, Subscription, Swipe, Thank, Neighborhood, OrganizerDataPoint, Post, Referral, Reply, Request, Resident, Subscription, Swipe, Thank, User]

  # Add models here if you want to go 'whitelist mode':
  # config.included_models = [AdminUser, Announcement, AnnouncementCrossPosting, Attendance, Community, Essay, Event, EventCrossPosting, Feed, FeedOwner, Group, GroupPost, HalfUser, Invite, Membership, Message, Met, OrganizerDataPoint, Referral, Reply, Resident, Subscription, Swipe, Thank, Neighborhood, OrganizerDataPoint, Post, Referral, Reply, Request, Resident, Subscription, Swipe, Thank, User]

  # Application wide tried label methods for models' instances
  # config.label_methods << :description # Default is [:name, :title]

  #  ==> Global models configuration
  # config.models do
  #   # Configuration here will affect all included models in all scopes, handle with care!
  #
  #   list do
  #     # Configuration here will affect all included models in list sections (same for show, export, edit, update, create)
  #
  #     fields_of_type :date do
  #       # Configuration here will affect all date fields, in the list section, for all included models. See README for a comprehensive type list.
  #     end
  #   end
  # end
  #
  #  ==> Model specific configuration
  # Keep in mind that *all* configuration blocks are optional.
  # RailsAdmin will try his best to provide the best defaults for each section, for each field.
  # Try to override as few things as possible, in the most generic way. Try to avoid setting labels for models and attributes, use ActiveRecord I18n API instead.
  # Less code is better code!
  # config.model MyModel do
  #   # Cross-section field configuration
  #   object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #   label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #   label_plural 'My models'      # Same, plural
  #   weight -1                     # Navigation priority. Bigger is higher.
  #   parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #   navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  #   # Section specific configuration:
  #   list do
  #     filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #     items_per_page 100    # Override default_items_per_page
  #     sort_by :id           # Sort column (default is primary key)
  #     sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     # Here goes the fields configuration for the list view
  #   end
  # end

  # Your model's configuration, to help you get started:

  # All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible. (visible(true))

  # config.model AdminUser do
  #   # Found associations:
  #   # Found columns:
  #     configure :id, :integer
  #     configure :email, :string
  #     configure :password, :password         # Hidden
  #     configure :password_confirmation, :password         # Hidden
  #     configure :reset_password_token, :string         # Hidden
  #     configure :reset_password_sent_at, :datetime
  #     configure :remember_created_at, :datetime
  #     configure :sign_in_count, :integer
  #     configure :current_sign_in_at, :datetime
  #     configure :last_sign_in_at, :datetime
  #     configure :current_sign_in_ip, :string
  #     configure :last_sign_in_ip, :string
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Announcement do
  #   # Found associations:
  #     configure :community, :belongs_to_association
  #     configure :owner, :polymorphic_association
  #     configure :replies, :has_many_association
  #     configure :repliers, :has_many_association
  #     configure :thanks, :has_many_association
  #     configure :announcement_cross_postings, :has_many_association
  #     configure :groups, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :subject, :string
  #     configure :body, :text
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :private, :boolean
  #     configure :type, :string
  #     configure :url, :string
  #     configure :community_id, :integer         # Hidden
  #     configure :owner_type, :string         # Hidden
  #     configure :owner_id, :integer         # Hidden
  #     configure :tweet_id, :string
  #     configure :deleted_at, :datetime
  #     configure :replied_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model AnnouncementCrossPosting do
  #   # Found associations:
  #     configure :announcement, :belongs_to_association
  #     configure :group, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :announcement_id, :integer         # Hidden
  #     configure :group_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Attendance do
  #   # Found associations:
  #     configure :event, :belongs_to_association
  #     configure :user, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :event_id, :integer         # Hidden
  #     configure :user_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Community do
  #   # Found associations:
  #     configure :feeds, :has_many_association
  #     configure :neighborhoods, :has_many_association
  #     configure :announcements, :has_many_association
  #     configure :events, :has_many_association
  #     configure :users, :has_many_association
  #     configure :mets, :has_many_association
  #     configure :residents, :has_many_association
  #     configure :groups, :has_many_association
  #     configure :group_posts, :has_many_association
  #     configure :messages, :has_many_association
  #     configure :subscriptions, :has_many_association
  #     configure :posts, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :name, :string
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :slug, :string
  #     configure :zip_code, :string
  #     configure :logo_file_name, :string         # Hidden
  #     configure :logo, :paperclip
  #     configure :email_header_file_name, :string         # Hidden
  #     configure :email_header, :paperclip
  #     configure :signup_message, :text
  #     configure :organizer_email, :string
  #     configure :organizer_name, :string
  #     configure :organizer_avatar_file_name, :string         # Hidden
  #     configure :organizer_avatar, :paperclip
  #     configure :organizer_about, :text
  #     configure :time_zone, :string
  #     configure :households, :integer
  #     configure :core, :boolean
  #     configure :should_delete, :boolean
  #     configure :is_college, :boolean
  #     configure :launch_date, :date
  #     configure :google_docs_url, :string
  #     configure :discount_businesses, :serialized
  #     configure :feature_switches, :serialized
  #     configure :metadata, :serialized   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Essay do
  #   # Found associations:
  #     configure :user, :belongs_to_association
  #     configure :feed, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :subject, :string
  #     configure :body, :text
  #     configure :user_id, :integer         # Hidden
  #     configure :feed_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Event do
  #   # Found associations:
  #     configure :owner, :polymorphic_association
  #     configure :community, :belongs_to_association
  #     configure :referrals, :has_many_association
  #     configure :replies, :has_many_association
  #     configure :repliers, :has_many_association
  #     configure :attendances, :has_many_association
  #     configure :attendees, :has_many_association
  #     configure :thanks, :has_many_association
  #     configure :invites, :has_many_association
  #     configure :event_cross_postings, :has_many_association
  #     configure :groups, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :name, :string
  #     configure :description, :text
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :owner_id, :integer         # Hidden
  #     configure :owner_type, :string         # Hidden
  #     configure :cached_tag_list, :string
  #     configure :date, :date
  #     configure :start_time, :time
  #     configure :end_time, :time
  #     configure :source_feed_id, :string
  #     configure :address, :string
  #     configure :venue, :string
  #     configure :type, :string
  #     configure :host_group_name, :string
  #     configure :community_id, :integer         # Hidden
  #     configure :deleted_at, :datetime
  #     configure :replied_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model EventCrossPosting do
  #   # Found associations:
  #     configure :event, :belongs_to_association
  #     configure :group, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :event_id, :integer         # Hidden
  #     configure :group_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Feed do
  #   # Found associations:
  #     configure :community, :belongs_to_association
  #     configure :owners, :has_many_association
  #     configure :feed_owners, :has_many_association
  #     configure :events, :has_many_association
  #     configure :announcements, :has_many_association
  #     configure :essays, :has_many_association
  #     configure :subscriptions, :has_many_association
  #     configure :subscribers, :has_many_association
  #     configure :swipes, :has_many_association
  #     configure :swiped_visitors, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :name, :string
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :about, :text
  #     configure :phone, :string
  #     configure :website, :string
  #     configure :community_id, :integer         # Hidden
  #     configure :category, :string
  #     configure :cached_tag_list, :string
  #     configure :code, :string
  #     configure :claimed, :boolean
  #     configure :user_id, :integer         # Hidden
  #     configure :type, :string
  #     configure :feed_url, :string
  #     configure :avatar_file_name, :string         # Hidden
  #     configure :avatar, :paperclip
  #     configure :address, :string
  #     configure :hours, :string
  #     configure :slug, :string
  #     configure :twitter_name, :string
  #     configure :kind, :integer
  #     configure :password, :password         # Hidden
  #     configure :background_file_name, :string   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model FeedOwner do
  #   # Found associations:
  #     configure :feed, :belongs_to_association
  #     configure :user, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :feed_id, :integer         # Hidden
  #     configure :user_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Group do
  #   # Found associations:
  #     configure :community, :belongs_to_association
  #     configure :group_posts, :has_many_association
  #     configure :memberships, :has_many_association
  #     configure :subscribers, :has_many_association
  #     configure :event_cross_postings, :has_many_association
  #     configure :events, :has_many_association
  #     configure :announcement_cross_postings, :has_many_association
  #     configure :announcements, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :name, :string
  #     configure :slug, :string
  #     configure :about, :string
  #     configure :community_id, :integer         # Hidden
  #     configure :avatar_file_name, :string
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model GroupPost do
  #   # Found associations:
  #     configure :user, :belongs_to_association
  #     configure :group, :belongs_to_association
  #     configure :replies, :has_many_association
  #     configure :repliers, :has_many_association
  #     configure :thanks, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :subject, :string
  #     configure :body, :text
  #     configure :user_id, :integer         # Hidden
  #     configure :group_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :deleted_at, :datetime
  #     configure :replied_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model HalfUser do
  #   # Found associations:
  #     configure :community, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :first_name, :string
  #     configure :last_name, :string
  #     configure :password, :password         # Hidden
  #     configure :street_address, :string
  #     configure :email, :string
  #     configure :single_access_token, :string
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :middle_name, :string
  #     configure :community_id, :integer         # Hidden   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Invite do
  #   # Found associations:
  #     configure :inviter, :polymorphic_association
  #     configure :invitee, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :email, :string
  #     configure :inviter_id, :integer         # Hidden
  #     configure :inviter_type, :string         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :body, :text
  #     configure :invitee_id, :integer         # Hidden   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Membership do
  #   # Found associations:
  #     configure :user, :belongs_to_association
  #     configure :group, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :user_id, :integer         # Hidden
  #     configure :group_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :receive_method, :string   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Message do
  #   # Found associations:
  #     configure :user, :belongs_to_association
  #     configure :messagable, :polymorphic_association
  #     configure :replies, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :user_id, :integer         # Hidden
  #     configure :body, :text
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :subject, :string
  #     configure :messagable_id, :integer         # Hidden
  #     configure :messagable_type, :string         # Hidden
  #     configure :archived, :boolean
  #     configure :replied_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Met do
  #   # Found associations:
  #     configure :requestee, :belongs_to_association
  #     configure :requester, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :requestee_id, :integer         # Hidden
  #     configure :requester_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model OrganizerDataPoint do
  #   # Found associations:
  #   # Found columns:
  #     configure :id, :integer
  #     configure :organizer_id, :integer
  #     configure :address, :string
  #     configure :status, :string
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :lat, :float
  #     configure :lng, :float
  #     configure :attempted_geolocating, :boolean   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Referral do
  #   # Found associations:
  #     configure :event, :belongs_to_association
  #     configure :referee, :belongs_to_association
  #     configure :referrer, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :event_id, :integer         # Hidden
  #     configure :referee_id, :integer         # Hidden
  #     configure :referrer_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Reply do
  #   # Found associations:
  #     configure :repliable, :polymorphic_association
  #     configure :user, :belongs_to_association
  #     configure :thanks, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :body, :text
  #     configure :repliable_id, :integer         # Hidden
  #     configure :repliable_type, :string         # Hidden
  #     configure :user_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :official, :boolean   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Resident do
  #   # Found associations:
  #     configure :user, :belongs_to_association
  #     configure :community, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :first_name, :string
  #     configure :last_name, :string
  #     configure :metadata, :serialized
  #     configure :user_id, :integer         # Hidden
  #     configure :community_id, :integer         # Hidden
  #     configure :address, :string
  #     configure :logs, :serialized
  #     configure :email, :string
  #     configure :latitude, :decimal
  #     configure :longitude, :decimal   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Subscription do
  #   # Found associations:
  #     configure :user, :belongs_to_association
  #     configure :feed, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :user_id, :integer         # Hidden
  #     configure :feed_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :receive_method, :string   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Swipe do
  #   # Found associations:
  #     configure :feed, :belongs_to_association
  #     configure :user, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :feed_id, :integer         # Hidden
  #     configure :user_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Thank do
  #   # Found associations:
  #     configure :user, :belongs_to_association
  #     configure :thankable, :polymorphic_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :user_id, :integer         # Hidden
  #     configure :thankable_id, :integer         # Hidden
  #     configure :thankable_type, :string         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Neighborhood do
  #   # Found associations:
  #     configure :community, :belongs_to_association
  #     configure :users, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :name, :string
  #     configure :community_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :bounds, :serialized
  #     configure :latitude, :decimal
  #     configure :longitude, :decimal   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model OrganizerDataPoint do
  #   # Found associations:
  #   # Found columns:
  #     configure :id, :integer
  #     configure :organizer_id, :integer
  #     configure :address, :string
  #     configure :status, :string
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :lat, :float
  #     configure :lng, :float
  #     configure :attempted_geolocating, :boolean   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Post do
  #   # Found associations:
  #     configure :user, :belongs_to_association
  #     configure :community, :belongs_to_association
  #     configure :replies, :has_many_association
  #     configure :repliers, :has_many_association
  #     configure :thanks, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :body, :text
  #     configure :user_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :subject, :string
  #     configure :category, :string
  #     configure :community_id, :integer         # Hidden
  #     configure :sent_to_community, :boolean
  #     configure :published, :boolean
  #     configure :deleted_at, :datetime
  #     configure :replied_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Referral do
  #   # Found associations:
  #     configure :event, :belongs_to_association
  #     configure :referee, :belongs_to_association
  #     configure :referrer, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :event_id, :integer         # Hidden
  #     configure :referee_id, :integer         # Hidden
  #     configure :referrer_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Reply do
  #   # Found associations:
  #     configure :repliable, :polymorphic_association
  #     configure :user, :belongs_to_association
  #     configure :thanks, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :body, :text
  #     configure :repliable_id, :integer         # Hidden
  #     configure :repliable_type, :string         # Hidden
  #     configure :user_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :official, :boolean   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Request do
  #   # Found associations:
  #   # Found columns:
  #     configure :id, :integer
  #     configure :community_name, :string
  #     configure :name, :string
  #     configure :email, :string
  #     configure :sponsor_organization, :string
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Resident do
  #   # Found associations:
  #     configure :user, :belongs_to_association
  #     configure :community, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :first_name, :string
  #     configure :last_name, :string
  #     configure :metadata, :serialized
  #     configure :user_id, :integer         # Hidden
  #     configure :community_id, :integer         # Hidden
  #     configure :address, :string
  #     configure :logs, :serialized
  #     configure :email, :string
  #     configure :latitude, :decimal
  #     configure :longitude, :decimal   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Subscription do
  #   # Found associations:
  #     configure :user, :belongs_to_association
  #     configure :feed, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :user_id, :integer         # Hidden
  #     configure :feed_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :receive_method, :string   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Swipe do
  #   # Found associations:
  #     configure :feed, :belongs_to_association
  #     configure :user, :belongs_to_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :feed_id, :integer         # Hidden
  #     configure :user_id, :integer         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model Thank do
  #   # Found associations:
  #     configure :user, :belongs_to_association
  #     configure :thankable, :polymorphic_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :user_id, :integer         # Hidden
  #     configure :thankable_id, :integer         # Hidden
  #     configure :thankable_type, :string         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  # config.model User do
  #   # Found associations:
  #     configure :neighborhood, :belongs_to_association
  #     configure :community, :belongs_to_association
  #     configure :thanks, :has_many_association
  #     configure :swipes, :has_many_association
  #     configure :swiped_feeds, :has_many_association
  #     configure :attendances, :has_many_association
  #     configure :events, :has_many_association
  #     configure :posts, :has_many_association
  #     configure :group_posts, :has_many_association
  #     configure :announcements, :has_many_association
  #     configure :essays, :has_many_association
  #     configure :replies, :has_many_association
  #     configure :subscriptions, :has_many_association
  #     configure :feeds, :has_many_association
  #     configure :memberships, :has_many_association
  #     configure :groups, :has_many_association
  #     configure :feed_owners, :has_many_association
  #     configure :managable_feeds, :has_many_association
  #     configure :direct_events, :has_many_association
  #     configure :referrals, :has_many_association
  #     configure :sent_messages, :has_many_association
  #     configure :received_messages, :has_many_association
  #     configure :messages, :has_many_association
  #     configure :mets, :has_many_association
  #     configure :people, :has_many_association   #   # Found columns:
  #     configure :id, :integer
  #     configure :email, :string
  #     configure :password, :password         # Hidden
  #     configure :password_confirmation, :password         # Hidden
  #     configure :password_salt, :string         # Hidden
  #     configure :reset_password_token, :string         # Hidden
  #     configure :remember_token, :string         # Hidden
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :first_name, :string
  #     configure :last_name, :string
  #     configure :about, :text
  #     configure :neighborhood_id, :integer         # Hidden
  #     configure :interests, :text
  #     configure :goods, :text
  #     configure :receive_events_and_announcements, :boolean
  #     configure :admin, :boolean
  #     configure :state, :string
  #     configure :avatar_file_name, :string         # Hidden
  #     configure :avatar, :paperclip
  #     configure :address, :string
  #     configure :facebook_uid, :string
  #     configure :oauth2_token, :string
  #     configure :community_id, :integer         # Hidden
  #     configure :receive_weekly_digest, :boolean
  #     configure :post_receive_method, :string
  #     configure :middle_name, :string
  #     configure :latitude, :decimal
  #     configure :longitude, :decimal
  #     configure :referral_source, :string
  #     configure :last_login_at, :datetime
  #     configure :transitional_user, :boolean
  #     configure :referral_metadata, :string
  #     configure :generated_lat, :float
  #     configure :generated_lng, :float
  #     configure :emails_sent, :integer
  #     configure :remember_created_at, :datetime
  #     configure :authentication_token, :string
  #     configure :skills, :text
  #     configure :attempted_geolocating, :boolean
  #     configure :last_checked_inbox, :datetime
  #     configure :replies_count, :integer
  #     configure :posts_count, :integer
  #     configure :sign_in_count, :integer
  #     configure :current_sign_in_at, :datetime
  #     configure :last_sign_in_at, :datetime
  #     configure :current_sign_in_ip, :string
  #     configure :last_sign_in_ip, :string
  #     configure :private_metadata, :serialized
  #     configure :calculated_cp_credits, :integer
  #     configure :cp_credits_are_valid, :boolean
  #     configure :metadata, :serialized
  #     configure :card_id, :integer
  #     configure :reset_password_sent_at, :datetime   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
end
