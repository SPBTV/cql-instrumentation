require_relative 'lib/cql_instrumentation/version'

Gem::Specification.new do |spec|
  spec.name          = "cql-instrumentation"
  spec.version       = CqlInstrumentation::VERSION
  spec.authors       = ["Nikita Afanasenko"]
  spec.email         = ["nikita@afanasenko.name"]
  spec.summary       = %q{CQL queries and durations logging for cql-rb and Rails}
  spec.homepage      = "https://github.com/spbtv/cql-instrumentation"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport", "~> 4.0"
  spec.add_runtime_dependency "cql-rb", "~> 2.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
