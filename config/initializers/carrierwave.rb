if false && Rails.env.production?
  CarrierWave.configure do |config|
    config.cache_dir = "#{Rails.root}/tmp/uploads"
    config.delete_tmp_file_after_storage = false
    config.enable_processing = true
    config.fog_credentials = {
      :provider               => 'AWS',                        # required
      :aws_access_key_id      => ENV["AWS_ACCESS_KEY_ID"],     # required
      :aws_secret_access_key  => ENV["AWS_SECRET_ACCESS_KEY"], # required
      #:region                 => 'eu-west-1'                   # optional, defaults to 'us-east-1'
      #:hosts                  => 's3.example.com'              # optional, defaults to nil
      #:endpoint               => 'https://s3.example.com:8080' # optional, defaults to nil
    }
    config.fog_directory  = 'world-diary'                     # required
    # config.fog_public     = false                                   # optional, defaults to true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  end
end
