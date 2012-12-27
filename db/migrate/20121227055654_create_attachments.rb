class CreateAttachments < ActiveRecord::Migration

  def change
    create_table :attachments, :force => true do |t|
      t.belongs_to :subject
      t.string :attachment
      t.string :content_type
      t.integer :file_size
      t.integer :width
      t.integer :height
    end
  end

end
