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
  s.description = "Guard::LiveReload automatically reloads your browser when 'view' files are modified."

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = "guard-livereload"

  s.add_dependency 'guard',        '>= 0.4.0'
  s.add_dependency 'em-websocket', '>= 0.2.0'
  s.add_dependency 'multi_json',   '~> 1.0.3'

  s.add_development_dependency 'bundler',     '~> 1.0'
  s.add_development_dependency 'rspec',       '~> 2.5'
  s.add_development_dependency 'guard-rspec', '~> 0.2'

  s.files        = Dir.glob('{lib}/**/*') + %w[LICENSE README.rdoc]
  s.require_path = 'lib'
end
