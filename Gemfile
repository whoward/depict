source :rubygems
gemspec

if RUBY_PLATFORM =~ /linux/
   gem "libnotify"
end

if RUBY_PLATFORM =~ /darwin/
   gem "growl"
end

if RUBY_PLATFORM =~ /mswin/
   gem "rb-notifu"
end