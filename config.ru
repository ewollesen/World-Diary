# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require "dav4rack"

app = Rack::Builder.new do

  map "/" do
    run Wd::Application
  end

  map "/webdav/subjects/" do
    use Rack::CommonLogger
    use Rack::Session::Cookie, secret: Wd::Application.config.secret_key_base
    use Rack::Auth::Basic, "World Diary" do |username, password|
      user = User.find_for_authentication(email: username)
      user.dm? && user.valid_password?(password)
    end
    use Rack::ETag
    run DAV4Rack::Handler.new(resource_class: SubjectsIndexResource,
                              root_uri_path: "/webdav/subjects/")
  end

end

run app
