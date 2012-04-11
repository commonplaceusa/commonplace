class AddRepliesCountToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :replies_count, :integer
    Message.all.each do |message|
      message.replies_count = message.replies.count
      message.save
    end
  end
end
