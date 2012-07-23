
module Depict
   module Converters
      module UnixTimestamp

         def self.serialize(value)
            if value.respond_to? :utc
               value.utc.to_i * 1000
            else
               nil
            end
         end

         def self.deserialize(value)
            if value.respond_to? :to_f
               Time.at(value.to_f / 1000.0).utc
            else
               nil
            end
         end

      end
   end
end