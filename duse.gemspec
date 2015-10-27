# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'duse/version'

Gem::Specification.new do |s|
  s.name        = 'duse'
  s.version     = Duse::VERSION
  s.description = 'CLI and Ruby client library for duse'
  s.homepage    = 'https://github.com/duse-io/duse.rb'
  s.summary     = 'Duse client'
  s.license     = 'MIT'
  s.executables = ['duse']
  s.authors     = 'Frederic Branczyk'
  s.email       = 'fbranczyk@gmail.com'
  s.files       = `git ls-files -z`.split("\x0")

  s.add_runtime_dependency 'highline'
  s.add_runtime_dependency 'secret_sharing', '0.0.6'
  s.add_runtime_dependency 'faraday'
  s.add_runtime_dependency 'faraday_middleware'
  s.add_runtime_dependency 'tree_outline'
end

