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

    def run
      if args.empty?
        puts "No arguments given - try: ruby_patches_merger revision1 revision2,revision3"
      else
        require 'ruby_patches_merger/revisions'
        RubyPatchesMerger::Revisions.new(args).save_to("patches")
      end
    end
  end
end
