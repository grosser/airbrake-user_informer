# frozen_string_literal: true
require "bundler/setup"
require "bundler/gem_tasks"
require "bump/tasks"

task default: [:spec, :rubocop]

desc "Run unit tests"
task :spec do
  sh "rspec spec/ --warnings"
end

desc "Run rubocop"
task :rubocop do
  sh "rubocop"
end
