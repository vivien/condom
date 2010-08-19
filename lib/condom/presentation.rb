# The Condom module
module Condom
  # The Presentation class.
  # This class is used to produce Beamer presentation.
  class Presentation < Condom::Base
    attr_accessor :listings, :graphics, :math

      # The constructor.
      # Argument could be:
      # * nothing,
      # * the title of the document,
      # * a hash of options.
      def initialize(args = nil)
        # Need to initialize each variables else they won't exist in instance_variables.
        @listings = @graphics = @math = nil

        # The default options
        options = {
          :document_class => 'beamer',
          :title          => 'Présentation \LaTeX',
          :filename       => 'presentation',
          :listings       => false,
          :graphics       => true,
          :math           => false
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
        build "presentation.tex"
        File.rename("presentation.tex", "main.tex")
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
