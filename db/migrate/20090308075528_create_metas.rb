class CreateMetas < ActiveRecord::Migration
  def self.up
    create_table :metas do |t|
      t.integer :klass_id
      t.string :key
      t.string :name
      t.integer :kind_id

      t.timestamps
    end
  end

  def self.down
    drop_table :metas
  end
end
