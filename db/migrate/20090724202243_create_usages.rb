class CreateUsages < ActiveRecord::Migration
  def self.up
    create_table :usages do |t|
      t.datetime :period_from
      t.integer :min_used
      t.float :download
      t.string :fap
      t.float :upload
      t.integer :download_24hr
      t.integer :upload_24hr

      t.timestamps
    end
  end

  def self.down
    drop_table :usages
  end
end
