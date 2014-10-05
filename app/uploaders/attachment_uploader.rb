# encoding: utf-8

class AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  # include Sprockets::Helpers::RailsHelper

  MICRO_DIM = [80, 80]
  THUMB_DIM = [262, 262]

  storage :file

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

  version :thumb, if: :image? do
    process resize_to_face: THUMB_DIM
  end

  version :micro, :if => :image? do
    process resize_to_face: MICRO_DIM
  end


  protected

  def init_opencv
    @data ||= "/usr/share/opencv/haarcascades/haarcascade_frontalface_alt.xml"
    @detector ||= OpenCV::CvHaarClassifierCascade::load(@data)
    @faces = []
  end

  def face_detected?(orig)
    img = OpenCV::CvMat.load(orig.filename)
    @faces = @detector.detect_objects(img)
    @faces.length > 0
  end

  def do_something_else!(img, width, height)
    img.resize_to_fit!(width, height)
    img
  end

  def fit_to_face!(orig, width, height)
    # orig is Magick::Image
    # TODO can we load from a file-like object?
    img = OpenCV::CvMat.load(orig.filename)

    @detector.detect_objects(img).each do |region|
      ratio = [width / img.width.to_f, height / img.height.to_f].max
      center = {x: region.center.x / img.width,
                y: region.center.y / img.height}
      rect = crop_centered({width: img.width, height: img.height},
                           {width: width, height: height},
                           center)

      if Rails.env.development?
        # draws a black box over the face in thumbs
        b = Magick::Draw.new
        b.fill_color("white")
        b.fill_opacity(0.5)
        b.rectangle(region.top_left.x, region.top_left.y,
                    region.bottom_right.x, region.bottom_right.y)
        b.draw(orig)
      end

      # Same as above, but the OpenCV way
      # color = OpenCV::CvColor::Blue
      # img.rectangle!(region.top_left, region.bottom_right, color: color)

      orig.resize!(ratio)
      orig.crop!(rect[:left], rect[:top], width, height)
      break # FIXME figure out which is best
    end

    orig
  end

  def resize_to_face(width, height)
    init_opencv
    manipulate! do |orig|
      if face_detected?(orig)
        fit_to_face!(orig, width, height)
      else
        do_something_else!(orig, width, height)
      end
    end
  rescue StandardError => e
    Rails.logger.debug("Unhandled error while detecting faces #{e.message}")
  end

  def image?(attachment)
    attachment.content_type.include?("image")
  rescue StandardError => e
    Rails.logger.debug("Not an image #{e.message}")
    false
  end

  def crop_centered(img, thumb, center)
    ratio = [thumb[:height] / img[:height].to_f,
             thumb[:width] / img[:width].to_f].max
    resized = {width: img[:width] * ratio, height: img[:height] * ratio}
    rect = {}

    rect[:left] = resized[:width] * center[:x] - thumb[:width] / 2
    rect[:right] = resized[:width] * center[:x] + thumb[:width] / 2
    rect[:top] = resized[:height] * center[:y] - thumb[:height] / 2
    rect[:bottom] = resized[:height] * center[:y] + thumb[:height] / 2

    if rect[:left] < 0
      rect[:right] -= rect[:left]
      rect[:left] -= rect[:left]
    end
    if rect[:right] > resized[:width]
      diff = rect[:right] - resized[:width]
      rect[:left] -= diff
      rect[:right] -= diff
    end
    if rect[:top] < 0
      rect[:bottom] -= rect[:top]
      rect[:top] -= rect[:top]
    end
    if rect[:bottom] > resized[:height]
      diff = rect[:bottom] - resized[:height]
      rect[:top] -= diff
      rect[:bottom] -= diff
    end

    rect
  end

end
