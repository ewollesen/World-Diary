module XML

  def self.parse(xml_text)
    Document.parse(xml_text)
  end
end

require_dependency "xml/document"
require_dependency "xml/node"
