# encoding: utf-8

class AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include Sprockets::Helpers::RailsHelper

  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  version :thumb, :if => :image? do
    process :resize_to_fill => [262, 262]
  end


  protected

  def image?(attachment)
    img = ::Magick::Image.ping(attachment.file).first
  rescue StandardError => e
    Rails.logger.debug("Not an image #{e.message}")
    false
  end

end
