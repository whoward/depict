
module Guise
   module Presentable
      class UndefinedPresentationError < StandardError
      end

      def self.included(base)
         base.send(:extend, ClassMethods)
         base.send(:include, InstanceMethods)
      end

      module ClassMethods
         def guise_presentations
            @guise_presentations ||= {}
         end

         def define_presentation(name, options={}, &block)
            if options[:extends]
               extends_presenter = guise_presentations[options[:extends]]

               if extends_presenter == nil
                  raise UndefinedPresentationError.new("undefined presentation: #{options[:extends]}")
               end
            else
               extends_presenter = Guise::Presenter
            end

            guise_presentations[name] = extends_presenter.define(&block)
         end

         def new_from_presentation(name, attrs)
            object = self.new

            presenter_class = guise_presentations[name]

            if presenter_class
               presenter = presenter_class.new(object)
               presenter.attributes = attrs
            end

            object
         end

         def respond_to?(method, include_private=false)
            names = guise_presentations.keys

            if /^new_from_(#{names.join("|")})_presentation$/ =~ method.to_s
               true
            else
               super(method, include_private)
            end
         end

         def method_missing(method, *args)
            names = guise_presentations.keys

            match = /^new_from_(#{names.join("|")})_presentation$/.match(method.to_s)

            if match
               new_from_presentation(match[1].to_sym, *args)
            else
               super(method, *args)
            end
         end
      end

      module InstanceMethods
         def to_presentation(presentation)
            presenter = self.class.guise_presentations[presentation]

            if presenter
               presenter.new(self).to_hash
            else
               {}
            end
         end

         def respond_to?(method, include_private=false)
            names = self.class.guise_presentations.keys

            if /^to_(#{names.join("|")})_presentation$/ =~ method.to_s
               true
            else
               super(method, include_private)
            end
         end

         def method_missing(method, *args)
            names = self.class.guise_presentations.keys

            match = /^to_(#{names.join("|")})_presentation$/.match(method.to_s)

            if match
               to_presentation(match[1].to_sym)
            else
               super(method, *args)
            end
         end
      end

   end
end