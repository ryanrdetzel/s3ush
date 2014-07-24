# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 's3ush/version'

Gem::Specification.new do |spec|
  spec.name          = "s3ush"
  spec.version       = S3ush::VERSION
  spec.authors       = ["Ryan Detzel"]
  spec.email         = ["ryandetzel@gmail.com"]
  spec.summary       = %q{Traverse your s3 buckets and smush (optimize) the images.}
  spec.description   = %q{Traverse your s3 buckets and smush (optimize) the images.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec'

  spec.add_dependency "aws-s3"
  spec.add_dependency "httpclient"
  spec.add_dependency "json"

end
