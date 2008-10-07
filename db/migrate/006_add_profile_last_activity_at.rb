class AddProfileLastActivityAt < ActiveRecord::Migration
  def self.up
    add_column :profiles, :last_activity_at, :datetime
  end

  def self.down
    remove_column :profiles, :last_activity_at
  end
end
