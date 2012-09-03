# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'omniauth/hackid/version'

Gem::Specification.new do |s|
  s.name     = 'omniauth-hackid'
  s.version  = OmniAuth::HackID::VERSION
  s.authors  = ['Steve Yadlowsky']
  s.email    = ['grizlo42@gmail.com']
  s.summary  = 'HackID strategy for OmniAuth'
  s.homepage = 'https://github.com/HackBerkeley/omniauth-hackid'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'omniauth-oauth2', '~> 1.1'

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'rake'
end
