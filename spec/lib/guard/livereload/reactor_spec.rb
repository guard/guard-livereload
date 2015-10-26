RSpec.describe Guard::LiveReload::Reactor do
  let(:paths) { %w[stylesheets/layout.css stylesheets/style.css] }

  let(:sockets) { instance_double(described_class::Sockets) }

  before do
    allow(Guard::Compat::UI).to receive(:info)
    allow(Guard::Compat::UI).to receive(:debug)
    allow(Guard::Compat::UI).to receive(:error)
    allow(Guard::Compat::UI).to receive(:warning)

    allow(described_class::Sockets).to receive(:new).and_return(sockets)
  end

  describe '#reload_browser(paths = [])' do
    before do
      allow(sockets).to receive(:broadcast)
    end

    it 'displays a message' do
      expect(Guard::Compat::UI).to receive(:info).
        with('Reloading browser: stylesheets/layout.css stylesheets/style.css')
      new_live_reactor.reload_browser(paths)
    end

    it 'by default does not send notification' do
      expect(Guard::Compat::UI).to_not receive(:notify)
      new_live_reactor.reload_browser(paths)
    end

    it 'optionally pushes notification' do
      expect(Guard::Compat::UI).to receive(:notify).
        with(kind_of(String), have_key(:title))
      new_live_reactor(notify: true).reload_browser(paths)
    end

    context 'with multiple paths' do
      subject { new_live_reactor(*args) }

      let(:paths) { %w(foo.css bar.css) }

      context 'with default options' do
        let(:options) { { apply_css_live: false } }
        let(:args) { [] }

        it 'sends json data with options' do
          paths.each do |path|
            json = MultiJson.encode('command': 'reload', path: "#{Dir.pwd}/#{path}", liveCSS: true)
            expect(sockets).to receive(:broadcast).with(json)
          end
          subject.reload_browser(paths)
        end
      end

      context 'with custom options' do
        let(:options) { { apply_css_live: false } }
        let(:args) { [options] }

        it 'sends json data with custom options' do
          paths.each do |path|
            json = MultiJson.encode('command': 'reload', path: "#{Dir.pwd}/#{path}", liveCSS: false)
            expect(sockets).to receive(:broadcast).with(json)
          end
          subject.reload_browser(paths)
        end
      end
    end
  end

  describe '#_connect(ws)' do
    let(:ws)      { double.as_null_object }
    let(:reactor) { new_live_reactor }
    let!(:socket_list) { [] }

    before do
      allow(sockets).to receive(:add).with(ws) do |socket|
        socket_list << socket
      end

      allow(sockets).to receive(:internal_list).and_return(socket_list)
    end

    context 'when connected once' do
      it 'displays a message once' do
        expect(Guard::Compat::UI).to receive(:info).with('New browser connecting...')
        expect(Guard::Compat::UI).to receive(:info).with('New browser connected (total: 1)')
        reactor.send(:_connect, ws)
      end
    end

    context 'when already connected' do
      before do
        allow(Guard::Compat::UI).to receive(:info)
        reactor.send(:_connect, ws)
      end

      it 'displays a message with total' do
        expect(Guard::Compat::UI).to receive(:info).with('New browser connecting...')
        expect(Guard::Compat::UI).to receive(:info).with('New browser connected (total: 2)')
        reactor.send(:_connect, ws)
      end
    end
  end
end

def new_live_reactor(options = {})
  Guard::LiveReload::Reactor.new({ host: '0.0.0.0', port: '35729', apply_css_live: true, grace_period: 0 }.merge(options))
end
