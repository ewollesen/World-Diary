module XML
  module Document
    class Nokogiri < Base

      def self.parse(xml_text)
        new(xml_text)
      end

      def initialize(xml_text)
        @doc = ::Nokogiri::XML.fragment(xml_text)
      end

      def strip_tags(tag)
        (@doc/tag).each(&:remove)
      end

      def with_each(tag, &block)
        (@doc/tag).each {|n| XML::Node::Nokogiri.new(n)}
      end

      def to_xml
        @doc.to_xml
      end

    end
  end
end
