require 'guard/compat/test/template'

RSpec.describe Guard::LiveReload do
  describe 'template' do
    subject { Guard::Compat::Test::Template.new(described_class) }

    context 'Rails' do
      context 'with view template files' do
        it 'reloads full page' do
          expect(subject.changed('app/views/foo.haml')).to eq(%w(app/views/foo.haml))
          expect(subject.changed('app/views/foo.html.erb')).to eq(%w(app/views/foo.html.erb))
        end
      end

      context 'when static files changes' do
        it 'reloads just the assets' do
          expect(subject.changed('public/foo.html')).to eq(%w(public/foo.html))
          expect(subject.changed('public/foo.css')).to eq(%w(public/foo.css))
          expect(subject.changed('public/foo.js')).to eq(%w(public/foo.js))
          expect(subject.changed('public/foo.png')).to eq(%w(public/foo.png))
          expect(subject.changed('public/foo.gif')).to eq(%w(public/foo.gif))
          expect(subject.changed('public/foo.jpg')).to eq(%w(public/foo.jpg))
          expect(subject.changed('public/foo.jpeg')).to eq(%w(public/foo.jpeg))
        end
      end

      context 'with old Rails asset pipeline naming' do
        it 'reloads' do
          expect(subject.changed('app/assets/css/foo.css')).to eq(%w(/assets/foo.css))
          expect(subject.changed('app/assets/css/foo.css.scss')).to eq(%w(/assets/foo.css))
          expect(subject.changed('app/assets/css/foo.css.scss.erb')).to eq(%w(/assets/foo.css))

          expect(subject.changed('app/assets/css/foo.js')).to eq(%w(/assets/foo.js))
          expect(subject.changed('app/assets/css/foo.html')).to eq(%w(/assets/foo.html))
          expect(subject.changed('app/assets/css/foo.png')).to eq(%w(/assets/foo.png))
          expect(subject.changed('app/assets/css/foo.jpg')).to eq(%w(/assets/foo.jpg))
        end

        it 'handles edge cases' do
          expect(subject.changed('app/assets/css/foo.css.')).to eq([])
          expect(subject.changed('app/assets/css/foo.cssx')).to eq([])
          expect(subject.changed('app/assets/css/foo.cssx.scss')).to eq([])
          expect(subject.changed('app/assets/css/foo.bar.css')).to eq([])
        end
      end

      context 'with new Rails asset pipeline naming' do
        it 'reloads' do
          expect(subject.changed('app/assets/css/foo.scss')).to eq(%w(/assets/foo.css))
          expect(subject.changed('app/assets/css/foo.sass')).to eq(%w(/assets/foo.css))
          expect(subject.changed('app/assets/js/foo.coffee')).to eq(%w(/assets/foo.js))

          expect(subject.changed('app/assets/css/foo.sass.erb')).to eq(%w(/assets/foo.css))
        end

        it 'handles edge cases' do
          expect(subject.changed('app/assets/css/foo_sass')).to eq([])
          expect(subject.changed('app/assets/css/foo.sass.')).to eq([])
          expect(subject.changed('app/assets/css/foo..sass')).to eq([])
          expect(subject.changed('app/assets/css/foo.sassx')).to eq([])
          expect(subject.changed('app/assets/css/foo.cssx.scss')).to eq([])
          expect(subject.changed('app/assets/css/foo.bar.css')).to eq([])
        end
      end
    end
  end
end
