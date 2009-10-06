class MoveToPaperclip < ActiveRecord::Migration
  def self.up
    # Profiles
    add_column :profiles, :icon_file_name, :string
    add_column :profiles, :icon_content_type, :string
    add_column :profiles, :icon_file_size, :integer
    add_column :profiles, :icon_updated_at, :datetime
    
    Profile.find_each do |profile|
      next unless profile.old_icon
      profile.icon = File.new(profile.old_icon)
      profile.save
    end
    
    remove_column :profiles, :icon
    
    # Photos
    add_column :photos, :image_file_name, :string
    add_column :photos, :image_content_type, :string
    add_column :photos, :image_file_size, :integer
    add_column :photos, :image_updated_at, :datetime
    
    Photo.find_each do |photo|
      next unless photo.old_image
      photo.image = File.new(profile.old_image)
      photo.save
    end
    
    remove_column :photos, :image
  end

  def self.down
    # Profiles
    add_column :profiles, :icon, :string
    
    Profile.find_each do |profile|
      next unless profile.icon
      profile.old_icon = File.new(profile.icon.path)
      profile.save
    end
    
    remove_column :profiles, :icon_updated_at
    remove_column :profiles, :icon_file_size
    remove_column :profiles, :icon_content_type
    remove_column :profiles, :icon_file_name
    
    # Photos
    add_column :photos, :image, :string
    
    Photo.find_each do |photo|
      next unless photo.image
      photo.old_image = File.new(photo.image.path)
      photo.save
    end
    
    remove_column :photos, :image_updated_at
    remove_column :photos, :image_file_size
    remove_column :photos, :image_content_type
    remove_column :photos, :image_file_name
  end
end


# just for redundancy. we want this to be a reverdable migration.
class Profile < ActiveRecord::Base
  file_column :icon, :magick => {
    :versions => { 
      :big => {:crop => "1:1", :size => "150x150", :name => "big"},
      :medium => {:crop => "1:1", :size => "100x100", :name => "medium"},
      :small => {:crop => "1:1", :size => "50x50", :name => "small"}
    }
  }
  alias_method :old_icon=, :icon=
  alias_method :old_icon, :icon
  
  has_attached_file :icon, :styles => { :big => "150x150>", :medium => "100x100>", :small => "50x50>" }
end

class Photo < ActiveRecord::Base
  file_column :image, :magick => {
    :versions => { 
      :square => {:crop => "1:1", :size => "50x50", :name => "square"},
      :small => "175x250>"
    }
  }
  alias_method :old_image=, :image=
  alias_method :old_image, :image
  
  has_attached_file :image, :styles => { :square => "50x50#", :small => "175x250>"}
end