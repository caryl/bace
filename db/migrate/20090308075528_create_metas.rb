class CreateMetas < ActiveRecord::Migration
  def self.up
    create_table :metas do |t|
      t.integer :klass_id
      t.string :key
      t.string :name
      t.integer :assoc_klass_id
      t.string :joins
      t.string :renderer #临时方案
      t.string :editor
      t.timestamps
    end
  end

  def self.down
    drop_table :metas
  end
end
