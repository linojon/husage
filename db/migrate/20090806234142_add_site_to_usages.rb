class AddSiteToUsages < ActiveRecord::Migration
  def self.up
    add_column :usages, :site, :string
  end

  def self.down
    remove_column :usages, :site
  end
end
