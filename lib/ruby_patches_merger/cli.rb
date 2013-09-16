module RubyPatchesMerger
  class Cli
    attr_reader :args

    def self.run(args)
      cli = new(args)
      cli.run
    end

    def initialize(args)
      @args = args.map{|arg| arg.split(/[ ,]/)}.flatten
    end

    def help(message = nil)
      puts message if message
      puts <<HELP
Usage: ruby_patches_merger [download|help]

 - download revisions,list
 - help

HELP
    end

    def run
      case args[0]
      when 'download'
        require 'ruby_patches_merger/revisions'
        RubyPatchesMerger::Revisions.new(args[1..-1]).save_to("patches")
      when nil, 'help', '--help'
        help
      else
        help "Unknown arguments given '#{args*" "}'."
      end
    end
  end
end
