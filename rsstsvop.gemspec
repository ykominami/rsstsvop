# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rsstsvop/version'

Gem::Specification.new do |spec|
  spec.name          = 'rsstsvop'
  spec.version       = Rsstsvop::VERSION
  spec.authors       = ['yasuo kominami']
  spec.email         = ['ykominami@gmail.com']

  spec.summary       = 'get tsv file or rss via network and crate tables.'
  spec.description   = 'get tsv file or rss via network and crate tables.'
  spec.homepage      = ''
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'bundler'
  spec.add_runtime_dependency 'rake'
  spec.add_runtime_dependency 'rss'
  spec.add_runtime_dependency 'simpleoptparse'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'yard'
end
