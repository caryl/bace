class CreatePermissionMetas < ActiveRecord::Migration
  def self.up
    create_table :permission_metas do |t|
      t.integer :permission_id
      t.integer :meta_id
      t.string :include
      t.string :joins

      t.timestamps
    end
  end

  def self.down
    drop_table :permission_metas
  end
end