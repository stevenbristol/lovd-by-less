ActiveRecord::Schema.define :version => 0 do
  create_table :file_column_users, :force => true do |t|
    t.column :name,  :text, :nil => false
    t.column :email, :text, :nil => false
    t.column :avatar, :string
    t.column :icon, :string
  end
  create_table :paperclip_users, :force => true do |t|
    t.column :name,  :text, :nil => false
    t.column :email, :text, :nil => false
    
    t.column :avatar_file_name, :string
    t.column :avatar_content_type, :string
    t.column :avatar_file_size, :integer
    
    t.column :icon_file_name, :string
    t.column :icon_content_type, :string
    t.column :icon_file_size, :integer
  end
end