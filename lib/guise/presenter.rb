
module Guise
   class Presenter
      class << self
         def define(&block)
            klass = Class.new(self)
            klass.instance_eval(&block)
            klass
         end

         def mappings
            @mappings ||= superclass == Object ? [] : superclass.mappings.dup
         end

         def target_attribute_names
            mappings.map(&:target_name)
         end

         def maps(name, options={})
            mappings.push Mapping.new(name, options)
         end
      end

      def initialize(object)
         @object = object
      end

      def to_hash
         self.class.mappings.inject({}) {|attrs, mapping| mapping.serialize(@object, attrs); attrs }
      end

      def attributes=(attributes)
         self.class.mappings.each {|mapping| mapping.deserialize(@object, attributes) }
      end

      def respond_to?(method, include_private=false)
         if self.class.target_attribute_names.include? method
            return true
         else
            super(method, include_private)
         end
      end

      def method_missing(method, *args)
         mapping = self.class.mappings.detect {|x| x.target_name == method }

         if mapping
            attrs = {}
            mapping.serialize(@object, attrs)
            attrs[method]
         else
            super(method, *args)
         end
      end

   end
end