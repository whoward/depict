
module Guise
   class Mapping
      attr_reader :name

      attr_reader :target_name

      attr_reader :converter

      def initialize(name, options={})
         @name = name.to_sym

         @target_name = options.fetch(:as, @name)

         @converter = options[:with]
      end

      def serialize(object, attributes)
         value = object.send(name)
         
         if converter
            attributes[target_name] = converter.serialize(value)
         else
            attributes[target_name] = value
         end

         nil
      end

      def deserialize(object, attributes)
         value = attributes[target_name]

         if converter
            object.send("#{name}=", converter.deserialize(value))
         else
            object.send("#{name}=", value)
         end

         nil
      end
   end
end