class MoveToPaperclip < ActiveRecord::Migration
  DEFAULT_FILE_COLUMN_PATH = File.join(RAILS_ROOT, "public", 'system')
  
  def self.up
    # Profiles
    add_column :profiles, :icon_file_name, :string
    add_column :profiles, :icon_content_type, :string
    add_column :profiles, :icon_file_size, :integer
    add_column :profiles, :icon_updated_at, :datetime
    
    Profile.find_each do |profile|
      next unless profile.read_attribute('icon')
      profile.icon = File.new(File.join(DEFAULT_FILE_COLUMN_PATH, 'profile', 'icon', profile.id.to_s, profile.read_attribute('icon')))
      profile.save
    end
    
    remove_column :profiles, :icon
    
    # Photos
    add_column :photos, :image_file_name, :string
    add_column :photos, :image_content_type, :string
    add_column :photos, :image_file_size, :integer
    add_column :photos, :image_updated_at, :datetime
    
    Photo.find_each do |photo|
      next unless photo.read_attribute('image')
      photo.image = File.new(File.join(DEFAULT_FILE_COLUMN_PATH, 'photo', 'image', photo.id.to_s, photo.read_attribute('image')))
      photo.save
    end
    
    remove_column :photos, :image
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration.new('The migrations from file_column to paperclip is not reversable')
  end
end