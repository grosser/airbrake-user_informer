# frozen_string_literal: true
name = "airbrake-user_informer"
$LOAD_PATH << File.expand_path("../lib", __FILE__)
require "#{name.tr("-", "/")}/version"

Gem::Specification.new name, Airbrake::UserInformer::VERSION do |s|
  s.summary = "Show exception ids on error pages so users or support can track them down faster"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "https://github.com/grosser/#{name}"
  s.files = `git ls-files lib/ bin/ MIT-LICENSE`.split("\n")
  s.license = "MIT"
  s.required_ruby_version = ">= 2.2.0"
  s.add_runtime_dependency "railties", ">= 5.0.0", "< 5.2.0"
  s.add_runtime_dependency "rack"
  s.add_runtime_dependency "airbrake", "~> 6.0"
  s.add_runtime_dependency "airbrake-ruby", "~> 2.0"
end
