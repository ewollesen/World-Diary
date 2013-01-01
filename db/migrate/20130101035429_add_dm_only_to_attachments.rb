class AddDmOnlyToAttachments < ActiveRecord::Migration
  def change
    change_table(:attachments) do |t|
      t.boolean :dm_only, :default => true, :null => false
    end

    change_table(:veil_passes) do |t|
      t.boolean :includes_attachments, :default => false, :null => false
    end
  end
end
