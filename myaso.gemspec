# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'myaso/version'

Gem::Specification.new do |s|
  s.name         = 'myaso'
  s.version      = Myaso::Version.to_s
  s.authors      = [ 'Dmitry A. Ustalov', 'Konstantin Lukinskih' ]
  s.email        = 'dmitry@eveel.ru'
  s.homepage     = 'https://github.com/eveel/myaso'
  s.summary      = 'Tasty myaso is a nice morphological analyzer in Ruby.'
  s.description  = s.summary

  s.executables  = [ 'myaso' ]
  s.default_executable = 'myaso'

  s.files        = Dir.glob('lib/**/*.rb')
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'

  s.add_dependency 'activesupport', '>= 3.0.0'
  s.add_dependency 'i18n', '>= 0.4.1'
  s.add_dependency 'thor', '~> 0.14.0'
  s.add_dependency 'rspec', '~> 2.4.0'
  s.add_dependency 'daemons', '~> 1.1.0'
  s.add_dependency 'shkuph'

  s.add_development_dependency 'bluecloth', '~> 2.0.0'
  s.add_development_dependency 'yard', '~> 0.6.0'

  s.required_rubygems_version = '>= 1.3.5'
end
