class SplitEventTimeFields < ActiveRecord::Migration
  def self.up
    rename_column :events, :start_time, :start_datetime
    rename_column :events, :end_time, :end_datetime
    add_column :events, :date, :date
    add_column :events, :start_time, :time
    add_column :events, :end_time, :time
    Event.reset_column_information
    Event.all.each do |event|
      event.date = event.start_datetime.to_date
      event.start_time = event.start_datetime.to_time
      event.end_time = event.end_datetime.to_time if event.end_datetime
      event.save
    end
    remove_column :events, :start_datetime
    remove_column :events, :end_datetime
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
