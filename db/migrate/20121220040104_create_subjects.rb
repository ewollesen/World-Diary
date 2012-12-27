class CreateSubjects < ActiveRecord::Migration

  def change
    create_table :subjects, :force => true do |t|
      t.string :name, :null => false
      t.text :text, :null => false
      t.string :permalink, :null => false
      t.boolean :dm_only, :null => false, :default => true

      t.timestamps
    end
  end

end
