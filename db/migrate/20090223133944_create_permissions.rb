class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.string :name
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.string :remark
      t.boolean :public
      t.timestamps
    end
  end

  def self.down
    drop_table :permissions
  end
end
