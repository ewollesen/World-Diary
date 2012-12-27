class Attachment < ActiveRecord::Base
  belongs_to :subject

  mount_uploader :attachment, AttachmentUploader

  attr_accessible :attachment, :attachment_cache
end
