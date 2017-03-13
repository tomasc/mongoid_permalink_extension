# coding: utf-8

require 'stringex'

module MongoidPermalinkExtension
  class Permalink
    class << self
      def demongoize(value)
        value
      end

      def mongoize(value)
        return if value.nil? # FIXME: this way we can never set the value to nil
        value.to_s
             .gsub(/\A\s+|\s+\z/, '')
             .gsub(/([^[:upper:]](?=[[:upper:]]))|([a-z](?=\d+))/, '\1\2-')
             .gsub(/\//, '-')
             .gsub(/[-–—]+/, '-')
             .gsub(/[^\p{Alnum} -]/, '')
             .gsub(/\s+/, '-')
             .gsub(/[-]+/, '-')
             .gsub(/\A\-/, '')
             .gsub(/\b\w/) { $&.upcase }
             .to_ascii
      end
    end
  end
end
