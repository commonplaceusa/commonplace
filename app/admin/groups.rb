ActiveAdmin.register Group do
  index do
    column :name do |group|
      link_to group.name, admin_group_path(group)
    end
    column :slug
    column :about
    column :created_at
  end

  filter :name
  filter :slug
  filter :created_at
end
