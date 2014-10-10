module DmStripper

  def self.strip(text, user, has_vp=false)
    user ||= User.new

    xml_text = XML::Document.parse(text).tap do |doc|
      if user.dm?
        modify_for_dm(doc)
      elsif has_vp
        modify_for_vp(doc)
      else
        modify_for_user(doc)
      end
    end.to_xml
    fix_markdown_blockquotes(xml_text)
    # to_xml will replace ampersands with entities, but if we use to_text,
    # then it will strip HTML inserted by world_wiki or other manually
    # installed HTML.
  end


  private

  def self.fix_markdown_blockquotes(xml_text)
    xml_text.gsub(/^(\s+)&gt;/, "\\1>")
  end

  def self.modify_for_dm(doc)
    process_dm(doc)
    process_note(doc)
    process_vp(doc)
  end

  def self.modify_for_user(doc)
    doc.strip_tags("dm")
    doc.strip_tags("note")
    doc.strip_tags("vp")
  end

  def self.modify_for_vp(doc)
    doc.strip_tags("dm")
    process_note(doc)
    process_vp(doc)
  end

  def self.process_dm(doc)
    process_tag("dm", doc)
  end

  def self.process_note(doc)
    process_tag("note", doc)
  end

  def self.process_vp(doc)
    process_tag("vp", doc)
  end

  def self.process_tag(tag, doc)
    doc.with_each(tag) do |n|
      if /[\r\n]/ === n
        n.name = "div"
      else
        n.name = "span"
      end
      n["class"] = ((n["class"] || "") + " #{tag} #{alert_class(n, tag)}").strip
      n["markdown"] ||= "1"
    end
  end

  def self.alert_class(n, tag)
    return "" unless "div" == n.name
    case tag
    when "note"; "dm alert alert-success pull-right col-md-6 col-lg-5"
    when "dm"; "alert alert-info"
    when "vp"; "alert alert-warn"
    else ""
    end
  end

end
