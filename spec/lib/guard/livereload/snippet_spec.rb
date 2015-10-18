RSpec.describe Guard::LiveReload::Snippet do
  let(:options) { { foo: :bar } }

  let(:template) { '/foo/livereload.js.erb' }
  let(:contents) { '// <%= options[:foo] %>' }

  subject { described_class.new(template, options) }

  let(:tmpfile) { instance_double(Tempfile) }

  before do
    allow(File).to receive(:expand_path) do |*args|
      fail "stub called for File.expand_path(#{args.map(&:inspect) * ','})"
    end

    allow(IO).to receive(:read) do |*args|
      fail "stub called for IO.read(#{args.map(&:inspect) * ','})"
    end

    allow(IO).to receive(:read).with(template).and_return(contents)

    allow(Tempfile).to receive(:new).and_return(tmpfile)
    allow(tmpfile).to receive(:path).and_return('/tmp/livereload-123')
    allow(tmpfile).to receive(:write)
    allow(tmpfile).to receive(:close)
  end

  describe '#initialize' do
    it 'evaluates the js snippet file' do
      expect(tmpfile).to receive(:write).with('// bar')
      subject
    end

    it 'closes the tmpfile' do
      expect(tmpfile).to receive(:close)
      subject
    end
  end

  describe '#path' do
    it 'is set to a tmpfile with the ERB result' do
      expect(subject.path).to eq '/tmp/livereload-123'
    end
  end
end
