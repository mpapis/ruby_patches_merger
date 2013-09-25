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
Usage: ruby_patches_merger [download|combine|help]

 - download revisions,list - will download the given revisions to patches/
 - combine - will get ruby source(from rvm), apply patches/* on it and build combined.patch
 - help - show this message

HELP
    end

    def run
      case args[0]
      when 'download'
        require 'ruby_patches_merger/revisions'
        RubyPatchesMerger::Revisions.new(args[1..-1]).save_to("patches")
      when 'combine'
        require 'ruby_patches_merger/combinator'
        return RubyPatchesMerger::Combinator.new.combine("patches")
      when nil, 'help', '--help'
        help
      else
        help "Unknown arguments given '#{args*" "}'."
      end
    end
  end
end
