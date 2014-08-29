class CreateNotes < ActiveRecord::Migration

  def change
    create_table :notes, force: true do |t|
      t.string :name, null: false
      t.text :text, null: false
      t.text :vp_text, null: false
      t.text :anon_text, null: false
      t.string :permalink, null: false
      t.boolean :dm_only, null: false, default: true

      t.timestamps
    end
  end

end
