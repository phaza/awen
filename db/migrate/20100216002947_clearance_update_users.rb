class ClearanceUpdateUsers < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      t.string :salt, :limit => 128
      t.string :confirmation_token, :limit => 128
      t.boolean :email_confirmed, :default => false, :null => false
    end

    add_index :users, [:id, :confirmation_token]
    add_index :users, :remember_token
  end

  def self.down
    change_table(:users) do |t|
      t.remove :salt,:confirmation_token,:email_confirmed
    end
  end
end
