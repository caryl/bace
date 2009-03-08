class CreateLimitScopes < ActiveRecord::Migration
  def self.up
    create_table :limit_scopes do |t|
      t.integer :role_id
      t.integer :permission_id
      t.integer :key_id
      t.string :prefix
      t.string :op
      t.integer :value_meta_id
      t.string :value
      t.string :suffix
      t.string :logic
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :limit_scopes
  end
end
