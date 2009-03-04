class CreatePermissionsRoles < ActiveRecord::Migration
  def self.up
    create_table :permissions_roles do |t|
      t.integer :permission_id
      t.integer :role_id
      t.boolean :granted

      t.timestamps
    end
  end

  def self.down
    drop_table :permissions_roles
  end
end
