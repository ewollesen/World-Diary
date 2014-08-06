class YamlAttachment < Attachment

  def self.from_attachment(attachment)
    if attachment.persisted?
      find(attachment.id)
    else
      new(attachment.attributes)
    end
  end

  def render_to_yaml_hash
    attributes
      .except("updated_at")
      .except("created_at")
      .except("subject_id")
  end

  def render_to_yaml
    render_to_yaml_hash.to_yaml
  end

end
