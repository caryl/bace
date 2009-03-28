class CreatePermissionsMetas < ActiveRecord::Migration
  def self.up
    create_table :permissions_metas do |t|
      t.integer :permission_id
      t.integer :meta_id
      t.string :include
      t.string :joins
      t.integer :target_id

      t.timestamps
    end
  end

  def self.down
    drop_table :permissions_metas
  end
end
