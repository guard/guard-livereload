group :specs, halt_on_fail: true do
  guard :rspec, cmd: 'bundle exec rspec', failed_mode: :keep, all_on_start: true do
    watch(%r{spec/.+_spec.rb})
    watch(%r{lib/(.+)\.rb})    { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb') { 'spec' }
    watch('lib/guard/livereload/templates/Guardfile') { 'spec/lib/guard/livereload/template_spec.rb' }
  end

  guard :rubocop, all_on_start: false, cli: '--rails' do
    watch(%r{.+\.rb$}) { |m| m[0] }
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
    watch(%r{(?:.+/)?\.rubocop_todo\.yml$}) { |m| File.dirname(m[0]) }
  end
end
