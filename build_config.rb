MRuby::Build.new do |conf|
  conf.toolchain

  conf.cc do |cc|
    cc.flags = %w(-Werror -Wall -fPIC)
  end

  conf.gem '.'

  conf.enable_debug
end
