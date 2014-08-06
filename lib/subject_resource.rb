class SubjectResource < DAV4Rack::Resource

  def get(request, response)
    resource = load_resource(request)
    # TODO can I use cancan to load and authorize resources?
    # TODO How to hook in devise auth?

    if resource
      response.body = resource.attributes.to_yaml
    else
      response.status = 404
      response.body = "Not found"
    end

    response
  end

  def delete
    Rails.logger.debug("DELETE NOW")
    resource = load_resource(request)

    unless resource.destroy
      response.code = 400
      response.error = resource.errors.to_s
    end
  end

  def post(request, response)
    resource = load_resource(request) || Subject.new
    attributes = YAML.load(URI.decode(request.body.read))

    if resource.update(attributes)
      response.body = "Good for you!"
    else
      response.status = 400
      response.body = resource.errors.to_s
    end

    response
  end

  # def setup(*args)
  #   Rails.logger.debug("SETUP SubjectResource")
  # end


  private

  def load_resource(request)
    permalink = request.path_info.slice(1..-1)

    Subject.where(permalink: permalink).first
  end

end
