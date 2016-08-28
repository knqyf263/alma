# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alma/version'

Gem::Specification.new do |spec|
  spec.name          = "alma"
  spec.version       = Alma::VERSION
  spec.authors       = ["Teppei Fukuda"]
  spec.email         = ["put.a.feud.pike011235@gmail.com"]

  spec.summary       = %q{Alert manager with DSL.}
  spec.description   = %q{Alma is an open source server software provides "Alert manager with DSL, written in JRuby, runs on JVM, licensed under GPLv2.}
  spec.homepage      = "https://github.com/knqyf263/alma"
  spec.license       = "GPLv2"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rack", "~>1.6.4"
  spec.add_runtime_dependency "thor"
  spec.add_runtime_dependency "msgpack-rpc-over-http", "~> 0.1.0"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
