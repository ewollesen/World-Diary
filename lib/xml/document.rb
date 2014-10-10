module XML
  module Document

    def self.parse(xml_text)
      Nokogiri.parse(xml_text)
    end

  end
end

require_dependency "xml/document/base"
require_dependency "xml/document/nokogiri"
