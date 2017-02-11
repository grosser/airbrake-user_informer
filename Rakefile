# frozen_string_literal: true
require "bundler/setup"
require "bundler/gem_tasks"
require "bump/tasks"

task default: [:spec, :rubocop]

desc "Run unit tests"
task :spec do
  sh "rspec spec/ --warnings"
end

desc "Run integration test"
task :integration do
  require "net/http"
  begin
    server = Bundler.with_clean_env { IO.popen("cd example && (bundle check || bundle) && rails s >/dev/null 2>&1", pgroup: true) }

    # wait 5s for server to respond
    10.times do
      result = Net::HTTP.get(URI.parse("http://0.0.0.0:3000")) rescue nil
      break if result == "Hello"
      sleep 0.5
    end

    # check that error pages include resolved airbrake url
    error = Net::HTTP.get(URI.parse("http://0.0.0.0:3000/error"))
    unless error =~ %r{Error number: <a href='https://airbrake.io/locate/[a-f\d-]{10,}'>}
      abort "Error page did not include airbrake error\n#{error}"
    end
  ensure
    # kill the server processgroup to kill all of it's children
    Process.kill(:SIGTERM, -Process.getpgid(server.pid)) rescue nil
  end
end

desc "Run rubocop"
task :rubocop do
  sh "rubocop"
end
