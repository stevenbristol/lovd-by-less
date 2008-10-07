class MoveTimezoneToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :time_zone, :string, :default => "UTC"
    remove_column :users, :time_zone
    execute "update profiles set time_zone='UTC'"
  end

  def self.down
    remove_column :profiles, :time_zone
    add_column :users, :time_zone, :string, :default => "UTC"
  end
end
