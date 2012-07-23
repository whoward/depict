
module Depict
   class Mapping
      attr_reader :name

      attr_reader :target_name

      attr_reader :converter

      attr_reader :serializer

      attr_reader :deserializer

      def initialize(name, options={})
         @name = name.to_sym

         @target_name = options.fetch(:as, @name)

         @converter = options[:with]

         @serializer = options[:serialize_with]

         @deserializer = options[:deserialize_with]
      end

      def serialize(object, attributes)
         value = object.send(name)
         
         if serializer
            attributes[target_name] = serializer.call(value)
         elsif converter
            attributes[target_name] = converter.serialize(value)
         else
            attributes[target_name] = value
         end

         nil
      end

      def deserialize(object, attributes)
         value = attributes[target_name]

         if deserializer
            object.send("#{name}=", deserializer.call(value))
         elsif converter
            object.send("#{name}=", converter.deserialize(value))
         else
            object.send("#{name}=", value)
         end

         nil
      end
   end
end