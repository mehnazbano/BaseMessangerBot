# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "messenger-bot"
  s.version = "1.0.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["JunSangPil"]
  s.bindir = "exe"
  s.date = "2016-08-27"
  s.description = "Ruby on Rails Gem for the Facebook Messenger Platform"
  s.email = ["jun85664396@gmail.com"]
  s.homepage = "https://github.com/jun85664396/messenger-bot-rails"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14.1"
  s.summary = "Ruby on Rails Gem for the Facebook Messenger Platform Formerly known as 'facebook-bot'."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.11"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>, ["~> 3.0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.11"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<rspec>, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.11"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<rspec>, ["~> 3.0"])
  end
end
