require 'stringex'

module MongoidPermalinkExtension
  class Permalink

    class << self

      def demongoize value
        value
      end

      def mongoize value
        return if value.nil?
        value.to_s.
          gsub(/–|—/, '-').
          gsub(/\s+/, '-').
          gsub(/[^\p{Alnum} -]/, '').
          gsub(/\b\w/){ $&.upcase }.
          to_ascii
      end

    end

  end
end
