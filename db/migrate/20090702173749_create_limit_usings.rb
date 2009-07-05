class CreateLimitUsings < ActiveRecord::Migration
  def self.up
    create_table :limit_usings do |t|
      t.integer :permissions_role_id
      t.integer :limit_group_id
      t.timestamps
    end
  end

  def self.down
    drop_table :limit_usings
  end
end
