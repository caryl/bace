class CreateKlassesPermissions < ActiveRecord::Migration
  def self.up
    create_table :klasses_permissions do |t|
      t.integer :klass_id
      t.integer :permission_id

      t.timestamps
    end
  end

  def self.down
    drop_table :klasses_permissions
  end
end
