class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.string :remark

      t.timestamps
    end
  end

  def self.down
    drop_table :roles
  end
end
