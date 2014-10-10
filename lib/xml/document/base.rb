module XML

  module Document

    class Base

      def self.parse(xml_text)
        raise NotImplementedError
      end

      def strip_tag(tag)
        raise NotImplementedError
      end

      def with_each(tag, &block)
        raise NotImplementedError
      end

      def to_xml
        raise NotImplementedError
      end

    end
  end

end
