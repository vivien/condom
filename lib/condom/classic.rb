# The Condom module
module Condom
  # The Classic class.
  # This class is used to produce classic documents such as article, report, book, etc.
  class Classic < Condom::Base
    attr_accessor :listings, :fancyhdr, :graphics, :math, :pdf

      # The constructor.
      # Argument could be:
      # * nothing,
      # * the title of the document,
      # * a hash of options.
      def initialize(args = nil)
        # Need to initialize each variables else they won't exist in instance_variables.
        @listings = @fancyhdr = @graphics = @math = @pdf = nil

        # The default options
        options = {
          :filename => 'classic',
          :listings => false,
          :fancyhdr => false,
          :graphics => false,
          :math     => false,
          :pdf      => true
        }

        if args.is_a? String
          options[:title] = args
        elsif args.is_a? Hash
          options.merge! args
        end

        super(options)
      end

    # This method will write in the output directory all needed files.
    def create
      in_directory do
        # Create files
        build "classic.tex"
        File.rename("classic.tex", "main.tex")
        build "Makefile"
        if @graphics
          build "fig.tex"
          Dir.mkdir "fig"
        end
        Dir.mkdir "src" if @listings
        Dir.mkdir "inc"
        Dir.chdir "inc" do
          build "packages.tex"
          build "commands.tex"
          build "colors.tex"
          build "listings.tex" if @listings
          build "first-page.tex" if @document_class == "report"
        end
      end
    end
  end
end
