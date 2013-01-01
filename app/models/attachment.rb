class Attachment < ActiveRecord::Base
  belongs_to :subject

  mount_uploader :attachment, AttachmentUploader

  attr_accessible :attachment, :attachment_cache, :dm_only

  before_save :update_metadata


  def image?
    /^image\// === content_type
  end


  private

  def update_metadata
    if attachment.present? && attachment_changed?
      self.content_type = attachment.file.content_type
      self.file_size = attachment.file.size

      img = ::Magick::Image::read(attachment.file.file).first
      self.width = img.columns
      self.height = img.rows
    end
  rescue StandardError => e
    logger.error("#{e.message}\n  #{e.backtrace.join("\n  ")}")
  end

end
