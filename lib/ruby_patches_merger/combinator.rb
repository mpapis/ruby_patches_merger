require 'fileutils'
require 'session'

module RubyPatchesMerger
  class Combinator

    def shell_run(message, command)
      @shell ||= Session::Bash.new
      printf(message) if message
      @shell.execute(command) do |out,err|
        printf(out) if out && message
        printf(err) if err
      end
      puts("") if message
      @last_status = @shell.status
      0 == @last_status
    end

    def get_source(version = "ruby-2.0.0-p247", archive_path = "#{ENV['rvm_path']}/archives")
      archive = "#{archive_path}/#{version}.tar.bz2"
      raise "Can not find archive #{archive}" unless File.exist?(archive)
      FileUtils.rm_rf('src/') if File.exist?('src/')
      FileUtils.mkdir_p('src/')
      shell_run("Extracting #{archive}", "tar xjf '#{archive}' -C src/ --strip 1")
      FileUtils.rm_rf('src_old/') if File.exist?('src_old/')
      FileUtils.cp_r('src/', 'src_old/')
    end

    def apply_patches(from)
      Dir["#{from}/*.patch"].each do |patch|
        shell_run( "Applying: #{patch}", "(cd src/ ; patch -p 1 <../#{patch})" )
      end
    end

    def combine(from = 'patches')
      get_source
      apply_patches(from)
      shell_run("Creating patch: combined.patch", "diff -ur src/ src_old/ > combined.patch")
      FileUtils.rm_rf('src/')
      FileUtils.rm_rf('src_old/')
      @last_status
    end

  end
end
