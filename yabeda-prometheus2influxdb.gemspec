# frozen_string_literal: true

require_relative "lib/yabeda/prometheus2influxdb/version"

Gem::Specification.new do |spec|
  spec.name = "yabeda-prometheus2influxdb"
  spec.version = Yabeda::Prometheus2InfluxDB::VERSION
  spec.authors = ["Andrey Novikov"]
  spec.email = ["envek@envek.name"]

  spec.summary = "Experimental gem to push metrics in Prometheus format to InfluxDB endpoint."
  spec.homepage = "https://github.com/yabeda-rb/yabeda-prometheus2influxdb"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/yabeda-rb/yabeda-prometheus2influxdb"
  spec.metadata["changelog_uri"] = "https://github.com/yabeda-rb/yabeda-prometheus2influxdb/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "anyway_config"
  spec.add_dependency "influxdb"
  spec.add_dependency "yabeda-prometheus"
end
