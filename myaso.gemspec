# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)

require 'myaso/version'

Gem::Specification.new do |s|
  s.name         = 'myaso'
  s.version      = Myaso::Version.to_s
  s.authors      = [ 'Dmitry A. Ustalov' ]
  s.email        = 'dmitry@eveel.ru'
  s.homepage     = 'http://github.com/eveel/myaso'
  s.summary      = 'Tasty myaso is a nice morphological analyzer in Ruby.'
  s.description  = s.summary

  s.files        = Dir.glob('lib/**/**')
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'

  s.add_dependency 'activesupport', '>= 3.0.0'
  s.add_dependency 'i18n', '>= 0.4.1'
  s.add_dependency 'thor', '>= 0.14.0'

  s.add_development_dependency 'yard', '>= 0.5.0'
  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'mg'

  s.required_rubygems_version = '>= 1.3.6'
end
