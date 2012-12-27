class CreateAttachments < ActiveRecord::Migration

  def change
    create_table :attachments, :force => true do |t|
      t.belongs_to :subject
      t.string :attachment
    end
  end

end
