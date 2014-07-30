class AddCaptionToAttachments < ActiveRecord::Migration
  def change
    change_table("attachments") do |t|
      t.string "caption"
    end
  end
end
