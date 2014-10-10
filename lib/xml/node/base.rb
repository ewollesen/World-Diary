module XML
  module Node
    class Base
      def name=(value)
        raise NotImplementedError
      end

      def []=(key, value)
        raise NotImplementedError
      end
    end
  end
end
