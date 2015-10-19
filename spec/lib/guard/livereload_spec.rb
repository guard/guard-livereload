require 'guard/compat/test/helper'

RSpec.describe Guard::LiveReload do
  let(:plugin) { Guard::LiveReload.new }
  let(:reactor) { double(Guard::LiveReload::Reactor) }

  let(:tmp_path) { '/tmp/livereload-123' }
  let(:snippet) { instance_double(Guard::LiveReload::Snippet, path: tmp_path) }

  before do
    allow(File).to receive(:expand_path) do |*args|
      fail "stub called for File.expand_path(#{args.map(&:inspect) * ','})"
    end

    allow(File).to receive(:expand_path).
      with('../../../js/livereload.js.erb', anything).
      and_return('/foo/js/livereload.js.erb')

    allow(Guard::LiveReload::Snippet).to receive(:new).and_return(snippet)

    allow(plugin).to receive(:reactor) { reactor }
  end

  describe '#initialize' do
    describe ':host option' do
      it "is '0.0.0.0' by default" do
        plugin = Guard::LiveReload.new
        expect(plugin.options[:host]).to eq '0.0.0.0'
      end

      it "can be set to '127.3.3.1'" do
        plugin = Guard::LiveReload.new(host: '127.3.3.1')
        expect(plugin.options[:host]).to eq '127.3.3.1'
      end
    end

    describe ':port option' do
      it "is '35729' by default" do
        plugin = Guard::LiveReload.new
        expect(plugin.options[:port]).to eq '35729'
      end

      it "can be set to '12345'" do
        plugin = Guard::LiveReload.new(port: '12345')
        expect(plugin.options[:port]).to eq '12345'
      end
    end

    describe ':apply_css_live option' do
      it 'is true by default' do
        plugin = Guard::LiveReload.new
        expect(plugin.options[:apply_css_live]).to be_truthy
      end

      it 'can be set to false' do
        plugin = Guard::LiveReload.new(apply_css_live: false)
        expect(plugin.options[:apply_css_live]).to be_falsey
      end
    end

    describe ':override_url option' do
      it 'is false by default' do
        plugin = Guard::LiveReload.new
        expect(plugin.options[:override_url]).to be_falsey
      end

      it 'can be set to false' do
        plugin = Guard::LiveReload.new(override_url: true)
        expect(plugin.options[:override_url]).to be_truthy
      end
    end

    describe ':grace_period option' do
      it 'is 0 by default' do
        plugin = Guard::LiveReload.new
        expect(plugin.options[:grace_period]).to eq 0
      end

      it 'can be set to 0.5' do
        plugin = Guard::LiveReload.new(grace_period: 0.5)
        expect(plugin.options[:grace_period]).to eq 0.5
      end
    end

    describe ':js_template option' do
      subject { described_class.new(*args) }

      context 'when no value is provided' do
        let(:args) { [] }

        it 'is set to full path to default JS' do
          expect(subject.options[:js_template]).to eq '/foo/js/livereload.js.erb'
        end

        it 'evalutes the default snippet' do
          expect(Guard::LiveReload::Snippet).to receive(:new).
            with('/foo/js/livereload.js.erb', anything).and_return(snippet)
          subject
        end
      end

      context 'with a custom path' do
        let(:args) { [js_template: 'foo/bar.js.erb'] }

        it 'is set to the given JS' do
          expect(subject.options[:js_template]).to eq 'foo/bar.js.erb'
        end

        it 'evalutes the provided snippet' do
          expect(Guard::LiveReload::Snippet).to receive(:new).
            with('foo/bar.js.erb', anything).and_return(snippet)
          subject
        end
      end
    end
  end

  describe '#start' do
    it 'creates reactor with default options' do
      plugin = Guard::LiveReload.new
      expect(Guard::LiveReload::Reactor).to receive(:new).with(
        host:           '0.0.0.0',
        port:           '35729',
        apply_css_live: true,
        override_url:   false,
        grace_period:  0,
        js_template: '/foo/js/livereload.js.erb',
        livereload_js_path: '/tmp/livereload-123'
      )
      plugin.start
    end

    it 'creates reactor with given options' do
      plugin = Guard::LiveReload.new(host: '127.3.3.1', port: '12345', apply_css_live: false, override_url: true, grace_period: 1)
      expect(Guard::LiveReload::Reactor).to receive(:new).with(
        host:           '127.3.3.1',
        port:           '12345',
        apply_css_live: false,
        override_url:   true,
        grace_period:   1,
        js_template: '/foo/js/livereload.js.erb',
        livereload_js_path: '/tmp/livereload-123'
      )
      plugin.start
    end
  end

  describe '#stop' do
    it 'stops the reactor' do
      expect(reactor).to receive(:stop)
      plugin.stop
    end
  end

  describe '#run_on_modifications' do
    it 'reloads browser' do
      expect(reactor).to receive(:reload_browser).with(['foo'])
      plugin.run_on_modifications(['foo'])
    end

    it 'can wait 0.5 seconds before reloading the browser' do
      expect(reactor).to receive(:reload_browser).with(['foo'])
      expect(plugin).to receive(:sleep).with(0.5)
      plugin.options[:grace_period] = 0.5
      plugin.run_on_modifications(['foo'])
    end
  end
end
