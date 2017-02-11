# frozen_string_literal: true
require "bundler/setup"

require "single_cov"
SingleCov.setup :rspec

require "airbrake/user_informer/version"
require "airbrake/user_informer"
require "airbrake-ruby/promise"
