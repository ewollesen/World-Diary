module DmStripper

  def self.strip(text, user, has_vp=false)
    user ||= User.new

    if user.dm?
      modify_for_dm(text)
    elsif has_vp
      modify_for_vp(text)
    else
      modify_for_user(text)
    end.to_xml.gsub(/^&gt;(\s)/, ">\\1") # maintains markdown blockquotes
  end


  private

  def self.modify_for_dm(text)
    Nokogiri::XML::fragment(text).tap do |doc|
      process_dm(doc)
      process_vp(doc)
    end
  end

  def self.modify_for_user(text)
    Nokogiri::XML::fragment(text).tap do |doc|
      (doc/"dm").each(&:remove)
      (doc/"vp").each(&:remove)
    end
  end

  def self.modify_for_vp(text)
    Nokogiri::XML::fragment(text).tap do |doc|
      (doc/"dm").each(&:remove)
      process_vp(doc)
    end
  end

  def self.process_dm(doc)
    process_tag("dm", doc)
  end

  def self.process_vp(doc)
    process_tag("vp", doc)
  end

  def self.process_tag(tag, doc)
    (doc/tag).each do |n|
      if /[\r\n]/ === n
        n.name = "div"
        # n.inner_html = WdMarkdown.render(n.inner_html)
      else
        n.name = "span"
      end
      n["class"] = ((n["class"] || "") + " #{tag}").strip
    end
  end
end
