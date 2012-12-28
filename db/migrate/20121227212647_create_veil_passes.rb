class CreateVeilPasses < ActiveRecord::Migration

  def change
    create_table :veil_passes, force: true do |t|
      t.belongs_to :subject, :null => false
      t.belongs_to :user, :null => false
    end
  end

end
