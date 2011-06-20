ActiveAdmin.register Request do
  index do
    column :community_name
    column :name
    column :email
    column :sponsor_organization
    column :created_at
  end
end
