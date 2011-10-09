class AddGoogleDocsLinkToCommunities < ActiveRecord::Migration
  def change
    add_column :communities, :google_docs_url, :string
  end
end
