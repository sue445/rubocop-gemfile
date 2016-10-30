# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubocop/gemfile/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubocop-gemfile'
  spec.version       = RuboCop::Gemfile::VERSION
  spec.authors       = ['sue445']
  spec.email         = ['sue445@sue445.net']

  spec.summary       = 'Code style checking for Gemfile'
  spec.description   = 'Code style checking for Gemfile'
  # TODO: make public
  # spec.homepage      = "https://github.com/sue445/rubocop-gemfile"
  spec.license       = 'MIT'

  spec.files =
    `git ls-files -z`
    .split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rubocop', '>= 0.35.0'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.5.0'
  spec.add_development_dependency 'rubocop', '0.44.1'
  spec.add_development_dependency 'yard'
end
