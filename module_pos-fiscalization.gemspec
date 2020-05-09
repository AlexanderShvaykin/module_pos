require_relative 'lib/module_pos/fiscalization/version'

Gem::Specification.new do |spec|
  spec.name          = "module_pos-fiscalization"
  spec.version       = ModulePos::Fiscalization::VERSION
  spec.authors       = ["Alexander Shvaykin"]
  spec.email         = ["skiline.alex@gmail.com"]

  spec.summary       = "API wrapper for Module Bank POS"
  spec.description   = "API wrapper for Module Bank POS"
  spec.homepage      = "http://github.com/AlexanderShvaykin/module_pos"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.5")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "http://github.com/AlexanderShvaykin/module_pos"
  spec.metadata["changelog_uri"] = "http://github.com/AlexanderShvaykin/module_pos/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency "faraday", "1.0.1"
  spec.add_dependency "api_utils", "0.1.1"
  spec.add_dependency "dry-types", "1.4.0"
  spec.add_dependency "dry-struct", "1.3.0"
end
