# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ancestry"
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stefan Kroes"]
  s.date = "2014-04-16"
  s.description = "  Ancestry allows the records of a ActiveRecord model to be organized in a tree\n  structure, using a single, intuitively formatted database column. It exposes\n  all the standard tree structure relations (ancestors, parent, root, children,\n  siblings, descendants) and all of them can be fetched in a single sql query.\n  Additional features are named_scopes, integrity checking, integrity restoration,\n  arrangement of (sub)tree into hashes and different strategies for dealing with\n  orphaned records.\n"
  s.email = "s.a.kroes@gmail.com"
  s.homepage = "http://github.com/stefankroes/ancestry"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14.1"
  s.summary = "Organize ActiveRecord model into a tree structure"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 3.0.0"])
    else
      s.add_dependency(%q<activerecord>, [">= 3.0.0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 3.0.0"])
  end
end
