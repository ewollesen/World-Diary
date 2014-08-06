class YamlVeilPass < VeilPass

  def self.from_veil_pass(veil_pass)
    if veil_pass.persisted?
      find(veil_pass.id)
    else
      new(veil_pass.attributes)
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
