# The Condom module
module Condom
  # The Letter class.
  # This class is used to produce a letter.
  class Letter < Condom::Base
    attr_accessor :address, :recipient, :recipient_address

      # The constructor.
      # Argument could be:
      # * nothing,
      # * the title of the document,
      # * a hash of options.
      def initialize(args = nil)
        # Need to initialize each variables else they won't exist in instance_variables.
        @address = @recipient = @recipient_address = nil

        # The default options
        options = {
          :document_class    => 'letter',
          :title             => 'Lettre \LaTeX',
          :filename          => 'letter',
          :address           => '',
          :recipient         => 'Mr John Smith',
          :recipient_address => ''
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
        build "letter.tex"
        File.rename("letter.tex", "main.tex")
        build "Makefile"
      end
    end
  end
end
