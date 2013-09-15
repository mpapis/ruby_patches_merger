require 'nokogiri'
require 'open-uri'
require 'fileutils'

module RubyPatchesMerger
  class Revisions

    class Revision

      class Link
        # href => /cgi-bin/viewvc.cgi/trunk/common.mk?r1=41352&r2=41351&pathrev=41352
        def initialize(href, base = 'http://svn.ruby-lang.org')
          @href = href
          @base = base
        end
        def name
          @href.split(/trunk\/|\?/)[1].gsub("/", "_")
        end
        def file_url
          "#{@base}#{@href}&view=patch"
        end
        def content
          "" + open(file_url).lines.to_a.join("")
        end
      end

      def initialize(revision, base = 'http://svn.ruby-lang.org')
        @revision = revision
        @revision = @revision[1..-1] if @revision.start_with?("r")
        @base = base
      end
      def revision_url
        "#{@base}/cgi-bin/viewvc.cgi?revision=#{@revision}&view=revision"
      end
      def content
        @content ||= Nokogiri::HTML(open(revision_url))
      end
      def hrefs
        content.css("a[title='View Diff']").map{|link| link["href"]}
      end
      def each_link(&block)
        hrefs.each{|href| block.call(Link.new(href, @base))}
      end
      def to_s
        @revision
      end
    end

    def initialize(strings, base = 'http://svn.ruby-lang.org')
      @strings = strings
      @base = base
    end
    def each_revision(&block)
      @strings.map{ |string| block.call(Revision.new(string, @base)) }
    end

    def save_to(path)
      FileUtils.mkdir_p(path)
      each_revision do |revision|
        file_path = File.join(path,"#{revision}.patch")
        puts file_path
        File.open(file_path, "w+")do |f|
          revision.each_link do |link|
            puts "# #{link.name}"
            f.write(link.content)
          end
        end
      end
    end

  end
end
