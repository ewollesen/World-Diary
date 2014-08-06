class SubjectsIndexResource < DAV4Rack::Resource
  YAML_OPTS = {line_width: 72, indentation: 2,}


  def collection?
    path.size == 0 || "." == path
  end

  def children
    if collection?
      subjects.map {|s| child(s)}
    else
      []
    end
  end

  def exist?
    subject = load_subject(request)

    subject.present? || collection?
  end

  def parent_collection?
    !collection?
  end

  def parent_exists?
    if collection?
      false
    else
      super
    end
  end

  def parent
    if collection?
      nil
    else
      super
    end
  end

  def content_type
    if collection?
      "text/html"
    else
      "application/x-yaml"
    end
  end

  def get(request, response)
    if collection?
      get_collection(request, response)
    else
      get_resource(request, response)
    end
  end

  def put(request, response)
    return super if collection?

    subject = load_subject(request) || Subject.new(name: path, text: "Enter text here.")
    attributes = YAML.load(URI.decode(request.body.read)) || {}

    if subject.update(attributes)
      response.body = "Good for you!"
    else
      response.status = 400
      response.body = subject.errors.to_s
    end

    response
  end

  def creation_date
    if collection?
      Subject.select("created_at").order("created_at").first.created_at
    else
      subject = load_subject(request)
      subject.created_at
    end
  rescue
    Time.at(0)
  end

  def last_modified
    if collection?
      Subject.select("updated_at").order(updated_at: :desc).first.updated_at
    else
      subject = load_subject(request)
      subject.updated_at
    end
  rescue
    Time.at(0)
  end

  def content_length
    # byebug
    if collection?
      get_collection_html.bytesize
    elsif subject = load_subject(request)
      subject.render_to_yaml.bytesize
    else
      super
    end.tap do |length|
      Rails.logger.debug("Content-Length: %d" % [length])
    end
  end


  private

  def get_collection_html
    html = ""
    html << "<html>\n<body>\n"
    html << "<ul>\n"
    subjects.each do |subject|
      html << "<li><a href=\"#{subject}\">#{subject}</a></li>\n"
    end
    html << "</ul>\n"
    html << "</body>\n</html>\n"
    html
  end

  def get_collection(request, response)
    response.body = get_collection_html
    OK
  end

  def get_resource(request, response)
    subject = load_subject(request)
    # TODO can I use cancan to load and authorize subjects?
    # TODO How to hook in devise auth?

    if subject
      response.body = subject.render_to_yaml
    else
      response.body = "Not Found"
    end

    response
  end

  def load_subject(request)
    request["_subject"] ||= {}
    request["_subject"][path] ||= load_subject_real(request)
  end

  def load_subject_real(request)
    YamlSubject.where(permalink: File.basename(path)).first
  end

  def subjects
    Subject.select("permalink").all.map(&:permalink)
  end

end
