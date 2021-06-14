# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'auditorb/version'

Gem::Specification.new do |spec|
  spec.name          = 'auditorb'
  spec.version       = Auditorb::VERSION
  spec.authors       = ['Andy Andrea']
  spec.email         = ['andy.andrea@scimedsolutions.com']
  spec.description   = 'An audit suite for a Ruby project'
  spec.summary       = 'A series of tools to help you determine useful information about a Ruby project'
  spec.homepage      = ''
  spec.license       = 'MIT'
  spec.files         = Dir['{lib,bin}/**/*'] + ['README.md', 'Gemfile']
  spec.executables   = spec.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'churn'
  spec.add_dependency 'colorize'
  spec.add_dependency 'rake'
  spec.add_dependency 'thor'
end
