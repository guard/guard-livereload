require 'spec_helper'

describe Guard::LiveReload do
  let(:plugin) { Guard::LiveReload.new }
  let(:reactor) { double(Guard::LiveReload::Reactor) }
  before { plugin.stub(:reactor) { reactor } }

  describe "#initialize" do
    describe ":host option" do
      it "is '0.0.0.0' by default" do
        plugin = Guard::LiveReload.new
        expect(plugin.options[:host]).to eq '0.0.0.0'
      end

      it "can be set to '127.3.3.1'" do
        plugin = Guard::LiveReload.new(host: '127.3.3.1')
        expect(plugin.options[:host]).to eq '127.3.3.1'
      end
    end

    describe ":port option" do
      it "is '35729' by default" do
        plugin = Guard::LiveReload.new
        expect(plugin.options[:port]).to eq '35729'
      end

      it "can be set to '12345'" do
        plugin = Guard::LiveReload.new(port: '12345')
        expect(plugin.options[:port]).to eq '12345'
      end
    end

    describe ":apply_css_live option" do
      it "is true by default" do
        plugin = Guard::LiveReload.new
        expect(plugin.options[:apply_css_live]).to be_true
      end

      it "can be set to false" do
        plugin = Guard::LiveReload.new(apply_css_live: false)
        expect(plugin.options[:apply_css_live]).to be_false
      end
    end

    describe ":override_url option" do
      it "is false by default" do
        plugin = Guard::LiveReload.new
        expect(plugin.options[:override_url]).to be_false
      end

      it "can be set to false" do
        plugin = Guard::LiveReload.new(override_url: true)
        expect(plugin.options[:override_url]).to be_true
      end
    end

    describe ":grace_period option" do
      it "is 0 by default" do
        plugin = Guard::LiveReload.new
        expect(plugin.options[:grace_period]).to eq 0
      end

      it "can be set to 0.5" do
        plugin = Guard::LiveReload.new(grace_period: 0.5)
        expect(plugin.options[:grace_period]).to eq 0.5
      end
    end
  end

  describe "#start" do
    it "creates reactor with default options" do
      plugin = Guard::LiveReload.new
      expect(Guard::LiveReload::Reactor).to receive(:new).with(
        host:           '0.0.0.0',
        port:           '35729',
        apply_css_live: true,
        override_url:   false,
        grace_period:  0
      )
      plugin.start
    end

    it "creates reactor with given options" do
      plugin = Guard::LiveReload.new(host: '127.3.3.1', port: '12345', apply_css_live: false, override_url: true, grace_period: 1)
      expect(Guard::LiveReload::Reactor).to receive(:new).with(
        host:           '127.3.3.1',
        port:           '12345',
        apply_css_live: false,
        override_url:   true,
        grace_period:   1
      )
      plugin.start
    end
  end

  describe "#stop" do
    it "stops the reactor" do
      expect(reactor).to receive(:stop)
      plugin.stop
    end
  end

  describe "#run_on_modifications" do
    it "reloads browser" do
      expect(reactor).to receive(:reload_browser).with(['foo'])
      plugin.run_on_modifications(['foo'])
    end

    it "can wait 0.5 seconds before reloading the browser" do
      expect(reactor).to receive(:reload_browser).with(['foo'])
      expect(plugin).to receive(:sleep).with(0.5)
      plugin.options[:grace_period] = 0.5
      plugin.run_on_modifications(['foo'])
    end
  end
end
