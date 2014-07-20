class AddUserAttributes < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.boolean :dm, :null => false, :default => false
    end
  end
end
