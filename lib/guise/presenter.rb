
module Guise
   class Presenter
      # Class Methods
      class << self
         def define(&block)
            klass = Class.new(self)
            klass.instance_eval(&block)
            klass
         end

         def mappings
            @mappings ||= superclass == Object ? [] : superclass.mappings.dup
         end

         def maps(name, options={})
            mappings.push Mapping.new(name, options)
         end
      end

      def initialize(object)
         @object = object
      end

      def to_hash
         self.class.mappings.inject({}) {|output, mapping| mapping.serialize(@object, output); output }
      end
   end
end