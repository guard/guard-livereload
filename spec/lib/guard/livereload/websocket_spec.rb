RSpec.describe Guard::LiveReload::WebSocket do
  let(:options) { { livereload_js_path: 'example_livereload.js' } }
  let(:signature) { 123 }
  subject { described_class.new(signature, options) }

  let(:dispatcher) { instance_double(described_class::Dispatcher) }

  before do
    allow(described_class::Dispatcher).to receive(:new).with(options).and_return(dispatcher)
  end

  describe '#initialize' do
    context 'with options' do
      let(:options) { {} }
      it 'passes options to dispatcher' do
        expect(described_class::Dispatcher).to receive(:new).with(options)
        subject
      end
    end
  end

  describe '#receive_data' do
    let(:data) { 'foo' }

    before do
      allow(dispatcher).to receive(:dispatch).and_return(response)
      allow(subject).to receive(:close_connection_after_writing)
      allow(subject).to receive(:close_connection)
      allow(subject).to receive(:send_data)
    end

    context 'with a request for allowed file' do
      let(:response) { [[:data, 'foobar'], [:file, './foo.js']] }
      let(:callback) { double(:callback) }

      before do
        allow(subject).to receive(:stream_file_data).and_return(callback)
        allow(callback).to receive(:callback) { |&block| block.call }
      end

      it 'send the HTTP content info' do
        expect(subject).to receive(:send_data).with('foobar')
        subject.receive_data(data)
      end

      it 'streams the file' do
        expect(subject).to receive(:stream_file_data).with('./foo.js').and_return(callback)
        subject.receive_data(data)
      end

      it 'closes the stream' do
        expect(subject).to receive(:close_connection_after_writing)
        subject.receive_data(data)
      end
    end

    context 'with a data response' do
      let(:response) { [[:data, 'hello'], [:close_write, nil]] }

      it 'responds with the data' do
        expect(subject).to receive(:send_data).with('hello')
        subject.receive_data(data)
      end

      it 'closes the stream' do
        expect(subject).to receive(:close_connection_after_writing)
        subject.receive_data(data)
      end
    end

    context 'with partial data' do
      let(:response) { [[:data, 'hello']] }

      it 'responds with the data' do
        expect(subject).to receive(:send_data).with('hello')
        subject.receive_data(data)
      end

      it 'does not close the stream' do
        expect(subject).to_not receive(:close_connection_after_writing)
        subject.receive_data(data)
      end
    end

    context 'with unhandled response' do
      let(:response) { [[:default, nil]] }

      it 'lets the socket process the request' do
        subject.receive_data(data)
      end

      it 'does not send data' do
        expect(subject).to_not receive(:send_data)
        subject.receive_data(data)
      end

      it 'does not close the stream' do
        expect(subject).to_not receive(:close_connection_after_writing)
        subject.receive_data(data)
      end
    end
  end
end
