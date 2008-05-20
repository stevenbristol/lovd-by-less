class CreateForums < ActiveRecord::Migration
  def self.up
    create_table :forums do |t|
      t.string :name
      t.text :description
      t.integer :position

      t.timestamps
    end
    
    create_table :forum_topics do |t|
      t.string :title
      t.integer :forum_id
      t.integer :owner_id

      t.timestamps
    end
    add_index :forum_topics, :forum_id
    
    create_table :forum_posts do |t|
      t.text :body
      t.integer :owner_id
      t.integer :topic_id

      t.timestamps
    end
      add_index :forum_posts, :topic_id
  end

  def self.down
    drop_table :forums
    drop_table :forum_topics
    drop_table :forum_posts
  end
end
