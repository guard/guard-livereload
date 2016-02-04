RSpec.describe Guard::LiveReload::WebSocket::Dispatcher do
  let(:options) { { livereload_js_path: '/tmp/foo.js.123' } }
  subject { described_class.new(options) }

  def http_request(type, path)
    [
      "#{type} #{path} HTTP/1.1",
      'Host: 127.0.0.1:35729',
      'Connection: keep-alive',
      'Accept: */*',
      'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36',
      'Referer: http://localhost:4000/foo.html',
      'Accept-Encoding: gzip, deflate, sdch',
      'Accept-Language: en-US,en;q=0.8,pl;q=0.6',
      '',
      ''
    ].join("\r\n")
  end

  describe '#dispatch' do
    context 'with a request for livereload.js' do
      let(:data) { http_request('GET', '/livereload.js?ext=Chrome&extver=2.1.0') }

      before do
        allow(File).to receive(:size).with('/tmp/foo.js.123').and_return(123)
      end

      it 'sends livereload files' do
        expected = "HTTP/1.1 200 OK\r\nContent-Type: application/ecmascript\r\nContent-Length: 123\r\n\r\n"
        expect(subject.dispatch(data)).to eq([[:data, expected], [:file, '/tmp/foo.js.123']])
      end
    end

    context 'with a non-GET request' do
      let(:data) { http_request('DELETE', '/livereload.js?ext=Chrome&extver=2.1.0') }

      it 'lets the socket process the request' do
        expect(subject.dispatch(data)).to eq([[:default, nil]])
      end
    end

    context 'with a request for a non-existing file' do
      let(:data) { http_request('GET', '/nosuchfile.js?ext=Chrome&extver=2.1.0') }

      it 'responds with a 404' do
        expected = "HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\nContent-Length: 13\r\n\r\n404 Not Found"
        expect(subject.dispatch(data)).to eq([[:data, expected], [:close_write, nil]])
      end
    end

    context 'with a request for file outside the project' do
      let(:data) { http_request('GET', '/./../Rakefile?ext=Chrome&extver=2.1.0') }

      before do
        allow(File).to receive(:readable?).with('././../Rakefile').and_return(true)
      end

      it 'responds with a 403' do
        expected = "HTTP/1.1 403 Forbidden\r\nContent-Type: text/plain\r\nContent-Length: 13\r\n\r\n403 Forbidden"
        expect(subject.dispatch(data)).to eq([[:data, expected], [:close_write, nil]])
      end
    end
  end
end
