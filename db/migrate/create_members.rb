class CreateMembers < ActiveRecord::Migration

  def self.up
    create_table :members do |t|
      t.string  :first_name
      t.string  :last_name
      t.string  :email
      t.string  :unique_identifier
      t.integer :position
      t.timestamps
    end

    add_index :members, :id

    load(Rails.root.join('db', 'seeds', 'members.rb'))
  end

  def self.down
    if defined?(UserPlugin)
      UserPlugin.destroy_all({:name => "members"})
    end

    if defined?(Page)
      Page.delete_all({:link_url => "/members"})
    end

    drop_table :members
  end

end
