module DmStripper

  def self.strip(text, user, has_vp=false)
    user ||= User.new

    if user.dm?
      modify_for_dm(text)
    elsif has_vp
      modify_for_vp(text)
    else
      modify_for_user(text)
    end.to_xml
      .gsub(/(\s)&amp;(\s)/, "\\1&\\2") # maintains ampersands in text
      .gsub(/^(\s*)&gt;(\s)/, "\\1>\\2") # maintains blockquotes
  end


  private

  def self.modify_for_dm(text)
    Nokogiri::XML::fragment(text).tap do |doc|
      process_dm(doc)
      process_note(doc)
      process_vp(doc)
    end
  end

  def self.modify_for_user(text)
    Nokogiri::XML::fragment(text).tap do |doc|
      (doc/"dm").each(&:remove)
      (doc/"note").each(&:remove)
      (doc/"vp").each(&:remove)
    end
  end

  def self.modify_for_vp(text)
    Nokogiri::XML::fragment(text).tap do |doc|
      (doc/"dm").each(&:remove)
      process_note(doc)
      process_vp(doc)
    end
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
    (doc/tag).each do |n|
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
