class CreateLimitGroups < ActiveRecord::Migration
  def self.up
    create_table :limit_groups do |t|
      t.integer :klass_id
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.string :logic
      t.string :remark
      t.integer :kind_id
      t.timestamps
    end
  end

  def self.down
    drop_table :limit_groups
  end
end
