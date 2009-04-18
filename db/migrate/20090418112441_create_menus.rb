class CreateMenus < ActiveRecord::Migration
  def self.up
    create_table :menus do |t|
      t.string :name
      t.integer :permission_id
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.string :icon
      t.string :url
      t.string :remark

      t.timestamps
    end
  end

  def self.down
    drop_table :menus
  end
end
