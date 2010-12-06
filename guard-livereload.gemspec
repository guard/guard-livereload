# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'guard/livereload/version'

Gem::Specification.new do |s|
  s.name        = "guard-livereload"
  s.version     = Guard::LiveReloadVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Thibaud Guillaume-Gentil']
  s.email       = ['thibaud@thibaud.me']
  s.homepage    = 'http://rubygems.org/gems/guard-livereload'
  s.summary     = 'Guard gem for livereload'
  s.description = "Guard::LiveReload automatically reload your browser when 'view' files are modified."
  
  s.rubyforge_project = "guard-livereload"
  
  s.add_dependency 'guard'
  s.add_dependency 'em-websocket', '~> 0.1.3'
  s.add_dependency 'json',         '~> 1.4.6'
  
  s.add_development_dependency 'bundler',     '~> 1.0.7'
  s.add_development_dependency 'guard-rspec', '~> 0.1.9'
  s.add_development_dependency 'rspec',       '~> 2.2.0'
  
  s.files        = Dir.glob('{lib}/**/*') + %w[LICENSE README.rdoc]
  s.require_path = 'lib'
end
