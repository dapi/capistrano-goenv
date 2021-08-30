# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'capistrano-goenv/version'

Gem::Specification.new do |spec|
  spec.name          = 'capistrano-goenv'
  spec.version       = CapistranoNvm::VERSION
  spec.authors       = ['Koen Punt']
  spec.email         = ['me@koen.pt']
  spec.description   = %q{goenv support for Capistrano 3.x}
  spec.summary       = %q{goenv support for Capistrano 3.x}
  spec.homepage      = 'https://github.com/koenpunt/capistrano-goenv'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'capistrano', '~> 3.1'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
