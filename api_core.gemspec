# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'api_core/version'

Gem::Specification.new do |spec|
  spec.name          = 'api_core'
  spec.version       = ApiCore::VERSION
  spec.authors       = ['Dmitriy Bielorusov']
  spec.email         = ['d.belorusov@gmail.com']
  spec.summary       = 'APIs Core Solutions'
  spec.description   = 'APIs Core Solutions'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'warden'
  spec.add_development_dependency 'rack'
  spec.add_development_dependency 'i18n'
  spec.add_development_dependency 'activerecord'
  spec.add_development_dependency 'activemodel'
end
