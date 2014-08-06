class YamlSubject < Subject

  def self.from_subject(subject)
    if subject.persisted?
      find(subject.id)
    else
      new(subject.attributes)
    end
  end

  def render_to_yaml_hash
    attributes
      .except("updated_at")
      .except("created_at")
      .except("anon_text")
      .except("vp_text")
      .merge("text" => string_literal(attributes["text"]))
      .merge("tag_list" => tag_list.to_a)
      .merge("attachments_attributes" => attachments.map {|a| a.render_to_yaml_hash})
      .merge("veil_passes_attributes" => veil_passes.map {|vp| vp.render_to_yaml_hash})
  end

  def render_to_yaml
    render_to_yaml_hash.to_yaml
  end

  def veil_passes
    super.map {|vp| YamlVeilPass.from_veil_pass(vp)}
  end

  def attachments
    super.map {|a| YamlAttachment.from_attachment(a)}
  end


  private

  def string_literal(text)
    # This triggers Psych to output a literal string, instead of an inline
    # string, the former being much easier to edit in an editor.
    Nokogiri::XML.fragment(text).to_xml
  end

end
