# coding: utf-8

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
          gsub(/([^[:upper:]](?=[[:upper:]]))|([a-z](?=\d+))/, '\1\2-').
          gsub(/\//, '-').
          gsub(/[-–—]+/, '-').
          gsub(/[^\p{Alnum} -]/, '').
          gsub(/\s+/, '-').
          gsub(/[-]+/, '-').
          gsub(/\b\w/){ $&.upcase }.
          to_ascii
      end

    end

  end
end
