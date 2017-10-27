# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "email_verifier"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kamil Ciemniewski"]
  s.date = "2015-09-22"
  s.description = "Helper utility checking if given email address exists or not"
  s.email = ["kamil@endpoint.com"]
  s.homepage = "http://endpoint.com"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14.1"
  s.summary = "Helper utility checking if given email address exists or not"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dnsruby>, [">= 1.5"])
    else
      s.add_dependency(%q<dnsruby>, [">= 1.5"])
    end
  else
    s.add_dependency(%q<dnsruby>, [">= 1.5"])
  end
end
