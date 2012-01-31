# A sample Guardfile
# More info at https://github.com/guard/guard#readme


guard 'spork' do
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
  watch('test/test_helper.rb') { :test_unit }
end

guard 'rspec', :cli => "--drb", :bundler => true do
  watch('spec/spec_helper.rb')                        { "spec" }
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^bin/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^bin/(.+)/(.+)\.rb$})  { |m| ["spec/#{m[1]}/#{m[2]}_spec.rb"] }
end
