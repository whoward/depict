# Description

Guise will be a presentation library for Ruby which will let you define multiple presentations for any Ruby class using a (hopefully) pleasant DSL.  It also includes the vital missing component from other presentation libraries which will be instantiating a new instance of a class from a presentation you specify - a common use case for this would be, for example, having multiple presentations of an object to support aging versions of a Web API.

# DSL

This will be how you define a presentation inline in your class:

```ruby
   class User
      include Guise
      
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
      include Guise
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

# So - what do you think?

I'll probably be starting to implement this shortly, I would love some feedback before I get started, 
feel free to contact me at the email address on my Github account.