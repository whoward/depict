# Description

Depict is a presentation library for Ruby which will let you define multiple presentations for any Ruby class using a (hopefully) pleasant DSL.  It also includes the vital missing component from other presentation libraries which will be instantiating a new instance of a class from a presentation you specify - a common use case for this would be, for example, having multiple presentations of an object to support aging versions of a Web API.

# DSL

This will be how you define a presentation inline in your class:

```ruby
   class User
      include Depict
      
      # presentation for unprivileged users
      define_presentation :user do
         maps :id
         maps :email
      end
      
      # presentation for superusers
      define_presentation :admin, :extends => :user do
         maps :role
      end
   end
```

You will also be able to define presentations outside of your class if you want to break it up over several files

```ruby
   class User
      include Depict
   end
   
   User.define_presentation :user do
      maps :id
      maps :email
   end
   
   User.define_presentation :admin, :extends => :user do
      maps :role
   end
```

You'll be able to convert into a presentation using a standard parameterized method

```ruby
   >> person = User.new(:id => 1, :email => "foo@example.com", :role => "user")
   => #<User:0xb73df4c0>
   >> person.to_presentation(:user)
   => {:id => 1, :email => "foo@example.com"}
   >> person.to_presentation(:admin)
   => {:id => 1, :email => "foo@example.com", :role => "user"}
```

There will also be some method_missing magic

```ruby
   >> person = User.new(:id => 1, :email => "foo@example.com", :role => "user")
   => #<User:0xb73df4c0>
   >> person.to_user_presentation
   => {:id => 1, :email => "foo@example.com"}   
```

And you will be able to construct new objects from a given presentation

```ruby
   >> person = User.new_from_presentation(:user, {:email => "foo@example.com"})
   => #<User:0xb73df4c0>
   >> person.id
   => nil
   >> person.email
   => "foo@example.com"
```

Which also has some method_missing magic

```ruby
   >> person = User.new_from_user_presentation(:email => "foo@example.com")
   => #<User:0xb73df4c0>
   >> person.id
   => nil
   >> person.email
   => "foo@example.com"
```

And will inherently give you some help with against mass assignment protection

```ruby
  >> User.new_from_user_presentation(:role => "admin").role
  => nil
  >> User.new_from_admin_presentation(:role => "admin").role
  => "admin"
```

Back to the DSL - you'll be able to specify your own custom serializers, so the mapped value is more appropriate

```ruby
   class User
      include Depict
      
      # UNIX timestamp representations for javascript friendly presentations
      define_presentation :javascript do
         maps :created_at, :serializes_with => lambda { |x| x.utc.to_i * 1000 }
      end
      
      # ISO 8601 formatted timestamps for XML friendly presentations
      define_presentation :xml do
         maps :created_at, :serializes_with => lambda { |x| x.strftime('%Y-%m-%dT%H:%M:%S%z') }
      end
   end

```

Which has deserializer counterparts as well

```ruby
   class User
      include Depict
      
      # UNIX timestamp representations for javascript friendly presentations
      define_presentation :javascript do
         maps :created_at, :serializes_with => lambda { |x| x.utc.to_i * 1000 },
                           :deserializes_with => lambda { |x| Time.at((x / 1000).to_i).utc }
      end
      
      # ISO 8601 formatted timestamps for XML friendly presentations
      define_presentation :xml do
         maps :created_at, :serializes_with => lambda { |x| x.strftime('%Y-%m-%dT%H:%M:%S%z') },
                           :deserializes_with => lambda { |x| Date.iso8601(x) }
      end
   end

```

Both of which will be able to be DRYed up with a serializer/deserializer class of some kind

```ruby
   class UnixTimestampConverter
      def serialize(value)
         value.utc.to_i * 1000
      end
      def deserialize(value)
         Time.at((value / 1000).to_i).utc
      end
   end
   
   class IsoTimestampConverter
      def serialize(value)
         value.strftime('%Y-%m%dT%H:%M:%S%z')
      end
      def deserialize(value)
         Date.iso8601(value)
      end
   end

   class User
      include Depict
      
      # UNIX timestamp representations for javascript friendly presentations
      define_presentation :javascript do
         maps :created_at, :with => UnixTimestampConverter.new
      end
      
      # ISO 8601 formatted timestamps for XML friendly presentations
      define_presentation :xml do
         maps :created_at, :with => IsoTimestampConverter.new
      end
   end

```

Internally all of this syntactic sugar is managed by the ``Depict::Presenter`` class which can be used without
associating it directly with any model:

```ruby

   UserPresenter = Depict::Presenter.define do
      maps :id
      maps :name
      maps :role
   end

```

Which can be used for duck-typing and to promote DRYness:

```ruby

   UserPresenter.new(User.first).to_hash
   UserPresenter.new(Customer.first).to_hash

```
