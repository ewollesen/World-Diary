module XML
  module Node
    class Nokogiri < Base

      def initialize(node)
        @node = node
      end

      def name=(value)
        @node.name = value
      end

      def []=(key, value)
        @node[key] = value
      end

    end
  end
end
