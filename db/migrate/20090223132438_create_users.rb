class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login_name
      t.string :password
      t.string :user_name
      t.string :email
      t.string :remark
      t.integer :state_id

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
