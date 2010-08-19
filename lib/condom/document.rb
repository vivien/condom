# The Condom module
module Condom
  # The Document class.
  # This class is used to produce classic document such as article, report, etc.
  class Document < Condom::Base
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
          :filename => 'document',
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
        build "main.tex"
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
          build "lst-conf.tex" if @listings
          build "flyleaf.tex" if @document_class == "report"
        end
      end
    end
  end
end
