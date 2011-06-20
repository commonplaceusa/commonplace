ActiveAdmin.register User do
  index do
    column :email do |user|
      link_to user.email, admin_user_path(user)
    end
    column :first_name
    column :last_name
  end
end
