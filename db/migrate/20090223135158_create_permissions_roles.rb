class CreatePermissionsRoles < ActiveRecord::Migration
  def self.up
    create_table :permissions_roles do |t|
      t.integer :permission_id
      t.integer :role_id
      t.boolean :granted
      t.integer :record_limit_id
      t.integer :context_limit_id
      t.timestamps
    end
  end

  def self.down
    drop_table :permissions_roles
  end
end
