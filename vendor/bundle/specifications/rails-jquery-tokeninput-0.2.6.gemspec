# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rails-jquery-tokeninput"
  s.version = "0.2.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Evgeny Li"]
  s.date = "2015-03-03"
  s.description = "rails-jquery-tokeninput project integrates Tokeninput jQuery plugin which allows your users to select multiple items from a predefined list, using autocompletion as they type to find each item"
  s.email = ["exaspark@gmail.com"]
  s.homepage = "https://github.com/exAspArk/rails-jquery-tokeninput"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14.1"
  s.summary = "Porting Tokeninput plugin"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jquery-rails>, [">= 2"])
      s.add_development_dependency(%q<activemodel>, ["~> 4.1.9"])
      s.add_development_dependency(%q<actionpack>, ["~> 4.1.9"])
      s.add_development_dependency(%q<sprockets-rails>, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>, [">= 0"])
      s.add_development_dependency(%q<capybara>, [">= 0"])
      s.add_development_dependency(%q<poltergeist>, [">= 0"])
      s.add_development_dependency(%q<pry-byebug>, [">= 0"])
    else
      s.add_dependency(%q<jquery-rails>, [">= 2"])
      s.add_dependency(%q<activemodel>, ["~> 4.1.9"])
      s.add_dependency(%q<actionpack>, ["~> 4.1.9"])
      s.add_dependency(%q<sprockets-rails>, [">= 0"])
      s.add_dependency(%q<rspec-rails>, [">= 0"])
      s.add_dependency(%q<capybara>, [">= 0"])
      s.add_dependency(%q<poltergeist>, [">= 0"])
      s.add_dependency(%q<pry-byebug>, [">= 0"])
    end
  else
    s.add_dependency(%q<jquery-rails>, [">= 2"])
    s.add_dependency(%q<activemodel>, ["~> 4.1.9"])
    s.add_dependency(%q<actionpack>, ["~> 4.1.9"])
    s.add_dependency(%q<sprockets-rails>, [">= 0"])
    s.add_dependency(%q<rspec-rails>, [">= 0"])
    s.add_dependency(%q<capybara>, [">= 0"])
    s.add_dependency(%q<poltergeist>, [">= 0"])
    s.add_dependency(%q<pry-byebug>, [">= 0"])
  end
end
