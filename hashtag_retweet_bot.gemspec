# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{hashtag_retweet_bot}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Balint Erdi", "Jaime Iniesta", "Tomasz Stachewicz"]
  s.date = %q{2010-06-19}
  s.default_executable = %q{hashtag_retweet_bot}
  s.description = %q{Script that listens to a tag and retweets messages with that tag. Originally made for Scotland on Rails '09 by Mark Connell (http://github.com/rubaidh)}
  s.email = %q{jaimeiniesta@gmail.com}
  s.executables = ["hashtag_retweet_bot"]
  s.extra_rdoc_files = ["bin/hashtag_retweet_bot", "lib/bot.rb", "README.markdown"]
  s.files = ["bin/hashtag_retweet_bot", "create_db_table.rb", "feed.rb", "hashtag_retweet_bot.gemspec", "lib/bot.rb", "Manifest", "Rakefile", "README.markdown"]
  s.homepage = %q{http://github.com/tomash/hashtag_retweet_bot}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Hashtag_retweet_bot", "--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{hashtag_retweet_bot}
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Script that listens to a tag and retweets messages with that tag. Originally made for Scotland on Rails '09 by Mark Connell (http://github.com/rubaidh)}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<twitter>, [">= 0.9.7"])
      s.add_runtime_dependency(%q<activerecord>, [">= 0"])
      s.add_runtime_dependency(%q<feedzirra>, [">= 0.0.23"])
      s.add_development_dependency(%q<twitter>, [">= 0.9.7"])
      s.add_development_dependency(%q<activerecord>, [">= 0"])
      s.add_development_dependency(%q<feedzirra>, [">= 0.0.23"])
    else
      s.add_dependency(%q<twitter>, [">= 0.9.7"])
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<feedzirra>, [">= 0.0.23"])
      s.add_dependency(%q<twitter>, [">= 0.9.7"])
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<feedzirra>, [">= 0.0.23"])
    end
  else
    s.add_dependency(%q<twitter>, [">= 0.9.7"])
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<feedzirra>, [">= 0.0.23"])
    s.add_dependency(%q<twitter>, [">= 0.9.7"])
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<feedzirra>, [">= 0.0.23"])
  end
end
