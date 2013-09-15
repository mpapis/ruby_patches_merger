#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

Kernel.load(File.expand_path("../lib/ruby_patches_merger/version.rb", __FILE__))

Gem::Specification.new do |s|
  s.name        = "ruby_patches_merger"
  s.version     = RubyPatchesMerger::VERSION
  s.license     = 'Apache 2.0'
  s.authors     = ["Michal Papis"]
  s.email       = ["mpapis@gmail.com"]
  s.homepage    = "https://github.com/mpapis/ruby_patches_merger"
  s.summary     = %q{
    Help to manage ruby patches.
  }

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = %w( ruby_patches_merger )

  s.add_development_dependency "nokogiri"
  #s.add_development_dependency "smf-gem"
end
