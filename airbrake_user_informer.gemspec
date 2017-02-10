name = "airbrake_user_informer"
$LOAD_PATH << File.expand_path('../lib', __FILE__)
require "#{name.gsub("-","/")}/version"

Gem::Specification.new name, AirbrakeUserInformer::VERSION do |s|
  s.summary = "Show exception ids on error pages so users or support can track them down faster"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "https://github.com/grosser/#{name}"
  s.files = `git ls-files lib/ bin/ MIT-LICENSE`.split("\n")
  s.license = "MIT"
  s.required_ruby_version = '>= 2.1.0'
end
