module DmStripper

  def self.strip(text, user, has_vp=false)
    user ||= User.new
    if user.dm?
      modify_for_dm(text)
    elsif has_vp
      modify_for_vp(text)
    else
      modify_for_user(text)
    end
  end


  private

  def self.modify_for_dm(text)
    doc = Nokogiri::XML::fragment(text)
    (doc/"dm").each do |n|
      if /[\r\n]/ === n
        n.swap("<div class=\"dm\">#{n.to_xml}</div>")
      else
        n.swap("<span class=\"dm\">#{n.content}</span>")
      end
    end
    (doc/"vp").each do |n|
      if /[\r\n]/ === n
        n.swap("<div class=\"vp\">#{n.to_xml}</div>")
      else
        n.swap("<span class=\"vp\">#{n.content}</span>")
      end
    end
    doc.to_xml
  end

  def self.modify_for_user(text)
    doc = Nokogiri::XML::fragment(text)
    (doc/"dm").each(&:remove)
    (doc/"vp").each(&:remove)
    doc.to_xml
  end

  def self.modify_for_vp(text)
    doc = Nokogiri::XML::fragment(text)
    (doc/"dm").each(&:remove)
    (doc/"vp").each do |n|
      if /[\r\n]/ === n
        n.swap("<div class=\"vp\">#{n.to_xml}</div>")
      else
        n.swap("<span class=\"vp\">#{n.content}</span>")
      end
    end
    doc.to_xml
  end

end
