# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'guard/livereload/version'

Gem::Specification.new do |s|
  s.name         = "guard-livereload"
  s.version      = Guard::LiveReloadVersion::VERSION
  s.author       = 'Thibaud Guillaume-Gentil'
  s.email        = 'thibaud@thibaud.me'
  s.summary      = 'Guard plugin for livereload'
  s.description  = "Guard::LiveReload automatically reloads your browser when 'view' files are modified."
  s.homepage     = 'https://rubygems.org/gems/guard-livereload'
  s.license      = "MIT"

  s.files        = `git ls-files`.split($/)
  s.test_files   = s.files.grep(%r{^spec/})
  s.require_path = 'lib'

  s.add_dependency 'guard',        '~> 2.0'
  s.add_dependency 'em-websocket', '~> 0.5'
  s.add_dependency 'multi_json',   '~> 1.8'

  s.add_development_dependency 'bundler', '>= 1.3.5'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end
