require 'fileutils'
require 'session'

module RubyPatchesMerger
  class Combinator
    def get_source(version = "ruby-2.0.0-p247", archive_path = "#{ENV['rvm_path']}/archives")
      archive = "#{archive_patch}/#{version}.tar.bz2"
      raise "Can not find archive #{archive}" unless File.exist?(archive)
      FileUtils.rm_rf('src/') if File.exist?('src/')
      FileUtils.mkdir_p('src/')
      printf "Extracting #{archive}"
      shell = Session::Bash.new
      shell.execute("cd src/; tar xzvf '#{archive}' --strip 1") do |out,err|
        printf "." if out
        printf err if err
      end
    end
  end
end
