ENV['MRUBY_BUILD_DIR'] ||= File.expand_path('build', __dir__)
ENV['MRUBY_CONFIG'] ||= File.expand_path('build_config.rb', __dir__)
ENV['INSTALL_DIR'] ||= File.expand_path('bin', __dir__)

ENV.fetch('MRUBY_ROOT') do
  puts "MRUBY_ROOT must be set... exiting"
  exit(false)
end

load File.join(ENV.fetch('MRUBY_ROOT'), 'Rakefile')
