class CreateLimitScopes < ActiveRecord::Migration
  def self.up
    create_table :limit_scopes do |t|
      t.integer :limit_group_id
      t.integer :target_meta_id
      t.integer :target_klass_id
      t.integer :key_meta_id
      t.string :op
      t.integer :value_meta_id
      t.string :value
      t.integer :position
      t.integer :kind_id

      t.timestamps
    end
  end

  def self.down
    drop_table :limit_scopes
  end
end
