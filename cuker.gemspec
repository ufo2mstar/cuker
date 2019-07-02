
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cuker/version"

Gem::Specification.new do |spec|
  spec.name          = "cuker"
  spec.version       = Cuker::VERSION
  spec.authors       = ["ufo2mstar"]
  spec.email         = ["ufo2mstar@gmail.com"]

  spec.summary       = %q{Cucumber Summary Gem}
  spec.description   = %q{generates reports of your feature files and gives some customizable formatting options}
  spec.homepage      = "https://github.com/ufo2mstar/cuker"
  spec.license       = "MIT"

  # # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   # spec.metadata["allowed_push_host"] = "http://mygemserver.com"
  #
  #   spec.metadata["homepage_uri"] = spec.homepage
  #   spec.metadata["source_code_uri"] = spec.homepage
  #   spec.metadata["changelog_uri"] = "https://github.com/ufo2mstar/cuker/blob/master/CHANGELOG.md"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  # gem.executables   = ["cuker"]
  spec.require_paths = ["lib"]


  # https://guides.rubygems.org/specification-reference/
  spec.required_ruby_version = '~> 2.0'


  # Dev Deps
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "awesome_print", "~> 1.8"

  # Runtime Deps
  spec.add_runtime_dependency "require_all", "~> 2"
  spec.add_runtime_dependency "logging", "~> 2.2.2"

  spec.add_runtime_dependency "gherkin", "= 5.1"

  spec.add_runtime_dependency "rubyXL", "~> 3.4"
  spec.add_runtime_dependency "text-table", "~> 1.2"

  spec.add_runtime_dependency  "highline", "~> 2"
  # spec.add_runtime_dependency  "thor"
  # spec.add_runtime_dependency  "bindata"

end
