ActiveAdmin.register Feed do
  index do
    column :name do |feed|
      link_to feed.name, admin_feed_path(feed)
    end
    column :created_at
    column :about
    column :phone
    column :website
    column :category
    column :feed_url
    column :address
    column :slug
    column :twitter_name
  end

  filter :name
  filter :feed_url
  filter :twitter_name
end
