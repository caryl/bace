class CreateKlasses < ActiveRecord::Migration
  def self.up
    create_table :klasses do |t|
      t.string :name
      t.string :remark
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :klasses
  end
end
