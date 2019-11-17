# frozen_string_literal: true
module Airbrake
  module UserInformer
    module MiddlewareExtension
      def notify_airbrake(_, env)
        if Airbrake.user_information
          env[Middleware::ENV_KEY] = super
        else
          super
        end
      end
    end

    # stolen from https://github.com/airbrake/airbrake/blob/v4.3.8/lib/airbrake/user_informer.rb
    class Middleware
      ENV_KEY = "airbrake.promise"
      TIMEOUT = 1.0 # seconds
      STEPS = 100
      DEFAULT_PLACEHOLDER = "<!-- AIRBRAKE ERROR -->"

      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)

        if (replacement = Airbrake.user_information) && error_id = wait_for_error(env[ENV_KEY])
          replacement = replacement.gsub(/\{\{\s*error_id\s*\}\}/, error_id.to_s)
          body = replace_placeholder(replacement, body, headers)
          headers["Error-Id"] = error_id.to_s
        end
        [status, headers, body]
      end

      private

      # wait till airbrake is done reporting ... stop when it fails to report
      # TODO: use something nicer than sleep
      def wait_for_error(promise)
        return unless promise
        done = false
        error_id = nil
        promise.then { |notice| error_id = done = notice["id"] }
        promise.rescue { |_notice| done = true }
        STEPS.times do
          break if done
          sleep TIMEOUT / STEPS
        end
        error_id
      end

      # - body interface is .each so we cannot use anything else
      # - always call .close on the old body so it can get garbage collected if it is a File
      def replace_placeholder(replacement, body, headers)
        new_body = []
        body.each { |chunk| new_body << chunk.gsub(Airbrake.user_information_placeholder || DEFAULT_PLACEHOLDER, replacement) }
        headers["Content-Length"] = new_body.inject(0) { |sum, x| sum + x.bytesize }.to_s
        new_body
      ensure
        body.close if body&.respond_to?(:close)
      end
    end
  end
end

class << Airbrake
  attr_accessor :user_information
  attr_accessor :user_information_placeholder
end

if defined?(::Rails::Railtie)
  raise "Load airbrake before airbrake-user_informer" unless defined?(Airbrake::Rack)
  Airbrake::Rack::Middleware.prepend(Airbrake::UserInformer::MiddlewareExtension)

  module Airbrake
    module UserInformer
      class Railtie < ::Rails::Railtie
        initializer("airbrake.user_informer") do |app|
          insertion_point = (::Rails::VERSION::MAJOR >= 5 ? ::Rack::Runtime : "Rack::Runtime")
          app.config.middleware.insert_before(insertion_point, Airbrake::UserInformer::Middleware)
        end
      end
    end
  end
end
