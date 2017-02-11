# frozen_string_literal: true
require "spec_helper"

SingleCov.covered! uncovered: 8 # if defined?(Rack) block is not tested

describe Airbrake::UserInformer do
  after do
    Airbrake.user_information = nil
    sleep 0.01 until Thread.list.size == 1 # make sure all threads are done
  end

  it "has a VERSION" do
    expect(Airbrake::UserInformer::VERSION).to match(/^[\.\da-z]+$/)
  end

  describe Airbrake::UserInformer::MiddlewareExtension do
    let(:klass) do
      Class.new do
        prepend Airbrake::UserInformer::MiddlewareExtension
        def notify_airbrake(*)
          "promise"
        end
      end
    end

    it "does nothing when user will not be notified" do
      env = {}
      klass.new.notify_airbrake(1, env)
      expect(env).to eq({})
    end

    it "stores the promise when user will be notified" do
      Airbrake.user_information = "foo"
      env = {}
      klass.new.notify_airbrake(1, env)
      expect(env).to eq("airbrake.promise" => "promise")
    end
  end

  describe Airbrake::UserInformer::Middleware do
    let(:promise) { Airbrake::Promise.new }
    let(:env) { {"airbrake.promise" => promise} }
    let(:body) { ["Original <!-- AIRBRAKE ERROR --> Body", "and more"] }
    let(:response) { [200, {}, body] }
    let(:app) { Airbrake::UserInformer::Middleware.new(->(_env) { response }) }
    let(:call) do
      Thread.new do
        sleep 0.05 # app sleeps in 0.01 intervals
        promise.resolve("id" => 12345)
      end
      app.call(env)
    end

    before { Airbrake.user_information = "Foo {{error_id}} bar" }

    it "informs the user of the error" do
      expect(app).to receive(:sleep).and_call_original.at_most(10)
      expect(call).to eq([200, {"Content-Length" => "35"}, ["Original Foo 12345 bar Body", "and more"]])
    end

    it "does nothing when user will not be notified" do
      Airbrake.user_information = nil
      expect(app).to_not receive(:sleep)
      expect(call).to eq([200, {}, ["Original <!-- AIRBRAKE ERROR --> Body", "and more"]])
    end

    it "replaces nothing when informer does not include placeholder" do
      Airbrake.user_information = "Foo bar"
      expect(app).to receive(:sleep).and_call_original.at_most(10)
      expect(call).to eq([200, {"Content-Length" => "29"}, ["Original Foo bar Body", "and more"]])
    end

    it "replaces multiple placeholders" do
      Airbrake.user_information = "Foo {{error_id}} bar {{error_id}}"
      expect(app).to receive(:sleep).and_call_original.at_most(10)
      expect(call).to eq([200, {"Content-Length" => "41"}, ["Original Foo 12345 bar 12345 Body", "and more"]])
    end

    it "does not blow up on empty body" do
      body.clear
      expect(app).to receive(:sleep).and_call_original.at_most(10)
      expect(call).to eq([200, {"Content-Length" => "0"}, []])
    end

    it "times out when notifying airbrake takes too long" do
      expect(app).to receive(:sleep).and_call_original.exactly(100)
      expect(app.call(env)).to eq([200, {}, ["Original <!-- AIRBRAKE ERROR --> Body", "and more"]])
    end

    it "stops early when notifying airbrake fails" do
      expect(app).to receive(:sleep).and_call_original.at_most(10)
      Thread.new do
        sleep 0.05 # app sleeps in 0.01 intervals
        promise.reject("e")
      end
      expect(app.call(env)).to eq([200, {}, ["Original <!-- AIRBRAKE ERROR --> Body", "and more"]])
    end

    describe "when body is an IO" do
      class FakeIoBody
        def initialize(content)
          @content = content
          @closed = false
        end

        def each(&block)
          @content.each(&block)
        end

        def close
          @closed = true
        end

        def closed?
          @closed
        end
      end
      let(:body) { FakeIoBody.new(["Original <!-- AIRBRAKE ERROR --> Body", "and more"]) }

      before { expect(app).to receive(:sleep).and_call_original.at_most(10) }

      it "closes old body so it can be garbadge collected" do
        expect(call).to eq([200, {"Content-Length" => "35"}, ["Original Foo 12345 bar Body", "and more"]])
        expect(body.closed?).to eq true
      end

      it "closes old body so it can be garbadge collected when an exception happens during replacement" do
        response[1] = 1234 # make headers['Content-Length'] line blow up
        expect { call }.to raise_error(NoMethodError)
        expect(body.closed?).to eq true
      end
    end
  end
end
