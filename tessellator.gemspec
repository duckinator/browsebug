# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tessellator/version'

Gem::Specification.new do |spec|
  spec.name          = "tessellator"
  spec.version       = Tessellator::VERSION
  spec.authors       = ["Marie Markwell"]
  spec.email         = ["me@marie.so"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "cairo", "~> 1.12.9"
  spec.add_runtime_dependency "pango", "~> 2.2.2"
  spec.add_runtime_dependency "gtk3",  "~> 2.2.2"
  spec.add_runtime_dependency "httparty"
  spec.add_runtime_dependency "nokogiri"
  spec.add_runtime_dependency "mime-types"

  #spec.add_runtime_dependency "cairo-gobject", "~> 2.2.2"
  #spec.add_runtime_dependency "gir_ffi-gtk"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
