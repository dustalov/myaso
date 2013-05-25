# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'myaso/version'

Gem::Specification.new do |spec|
  spec.name          = 'myaso'
  spec.version       = Myaso::VERSION
  spec.authors       = ['Dmitry Ustalov', 'Sergey Smagin']
  spec.email         = ['dmitry@eveel.ru']
  spec.description   = 'Myaso is a morphological analysis library in Ruby.'
  spec.summary       = 'Myaso is a morphological analysis and synthesis ' \
                       'library in Ruby.'
  spec.homepage      = 'https://github.com/ustalov/myaso'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
end
