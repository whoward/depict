
module Guise
   module Converters
      class UnixTimestamp

         def serialize(value)
            if value.respond_to? :utc
               value.utc.to_i * 1000
            else
               nil
            end
         end

         def deserialize(value)
            
         end

      end
   end
end