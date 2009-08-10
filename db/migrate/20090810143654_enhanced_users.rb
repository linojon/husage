class EnhancedUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :fap_threshold, :integer
    add_column :users, :last_run_at, :datetime
    add_column :users, :time_zone, :string
  end

  def self.down
    remove_column :users, :time_zone
    remove_column :users, :last_run_at
    remove_column :users, :fap_threshold
  end
end
