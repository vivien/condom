# The Condom module
module Condom
  # The CV class.
  # This class is used to produce a résumé.
  class CV < Condom::Base
    attr_accessor :theme, :color

      # The constructor.
      # Argument could be:
      # * nothing,
      # * the title of the document,
      # * a hash of options.
      def initialize(args = nil)
        # Need to initialize each variables else they won't exist in instance_variables.
        @theme = @color = nil

        # The default options
        options = {
          :document_class => 'moderncv',
          :title          => 'Curriculum Vitae',
          :filename       => 'cv',
          :theme          => 'classic',
          :color          => 'grey'
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
        build "cv.tex"
        File.rename("cv.tex", "main.tex")
        build "Makefile"
      end
    end
  end
end

