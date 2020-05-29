Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-parser-protobuf"
  spec.version       = "0.1.0"
  spec.authors       = ["Hiroshi Hatake"]
  spec.email         = ["cosmo0920.wp@gmail.com"]

  spec.summary       = %q{Protobuf parser for Fluentd.}
  spec.description   = %q{Protobuf parser for Fluentd.}
  spec.homepage      = "https://github.com/cosmo0920/fluent-plugin-parser-protobuf"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/cosmo0920/fluent-plugin-parser-protobuf"
  spec.metadata["changelog_uri"] = "https://github.com/cosmo0920/fluent-plugin-parser-protobuf/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_development_dependency 'test-unit', '~> 3.3.0'
  spec.license = "Apache-2.0"

  spec.add_runtime_dependency "fluentd", [">= 1.0", "< 2"]
  spec.add_runtime_dependency "google-protobuf", ["~> 3.12"]
end
