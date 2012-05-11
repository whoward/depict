
module Guise
   class Mapping
      attr_reader :name

      attr_reader :converter

      def initialize(name, options={})
         @name = name.to_sym

         self.converter = options[:with]
      end

      def serialize(object, hash)
         value = object.send(name)
         
         if converter
            hash[name] = converter.serialize(value)
         else
            hash[name] = value
         end

         nil
      end

      # def deserialize(object)
      # end

      def converter=(conv)
         if conv == nil || !conv.is_a?(Class)
            @converter = conv
         else
            @converter = conv.new
         end
      end
   end
end