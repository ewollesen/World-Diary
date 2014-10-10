module XmlParser

  def self.parse(xml_text)
    Nokogiri::XML.fragment(xml_text)
  end

end
