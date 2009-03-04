class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.string :name
      t.string :controller
      t.string :action
      t.integer :permission_id

      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end
