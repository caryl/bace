class CreateDynamicSearches < ActiveRecord::Migration
  def self.up
    create_table :dynamic_searches do |t|
      t.integer :resource_id
      t.string :name
      t.integer :target_klass_id
      t.integer :target_meta_id
      t.integer :key_meta_id
      t.string :op
      t.integer :value_meta_id
      t.string :value
      t.integer :position
      t.boolean :readonly

      t.timestamps
    end
  end

  def self.down
    drop_table :dynamic_searches
  end
end
