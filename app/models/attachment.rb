class Attachment < ActiveRecord::Base
  belongs_to :subject, :touch => true

  mount_uploader :attachment, AttachmentUploader

  before_save :update_metadata

  has_many :veil_passes, -> {includes(:user).where(["veil_passes.includes_attachments = ?", true])}, through: :subject

  has_many :authorized_users, :through => :veil_passes, :source => :user


  def image?
    /^image\// === content_type
  end

  def authorized_user?(user)
    authorized_users.include?(user)
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
