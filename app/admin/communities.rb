ActiveAdmin.register Community do
  index do
    column :name do |name|
      link_to name.name, admin_community_path(name)
    end
    column :slug
    column :zip_code
    column :signup_message
    column :organizer_email
    column :organizer_name
    column :organizer_about
    column :households
  end
  filter :name
  filter :slug
  filter :zip_code
  filter :organizer_name
  filter :households
end
