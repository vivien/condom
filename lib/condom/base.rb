require "fileutils"
require "erb"

#TODO Split author with space to get firstname and lastname?

# The Condom module
module Condom
  # The Base class.
  # This is the main class of the condom lib.
  # It will contain all common attributes and methods to every LaTeX document.
  class Base
    attr_accessor :outputdir, :filename,
      :author, :title, :date, :document_class, :language,
      :other_packages

    # The constructor.
    # args could be:
    # * nothing,
    # * the title of the document,
    # * a hash of options.
    def initialize(args = nil)
      # Need to initialize each variables else they won't exist in instance_variables.
      @outputdir = @filename = @author = @title = @date = @document_class = @language = @other_packages = nil

      # The default options
      set_options({
        :outputdir      => Dir.getwd,
        :filename       => 'main',
        :author         => Condom.get_user_name,
        :title          => 'Document \LaTeX',
        :date           => '\today',
        :document_class => 'article',
        :language       => 'francais',
        :other_packages => Array.new
      })

      if args.is_a? String
        @title = args
      elsif args.is_a? Hash
        set_options args
      end
    end

    # This method returns a hash of the options of the document.
    def get_options
      hash = Hash.new
      instance_variables.each do |var|
        hash[var[1..-1].to_sym] = instance_variable_get(var)
      end

      return hash
    end

    # This method sets options of the document given in a hash
    def set_options(hash)
      hash.keys.each do |key|
        var = '@' << key.to_s
        raise("Key #{key} not supported.") unless instance_variables.include? var
        instance_variable_set(var, hash[key])
      end
    end

    # This method will create in output directory all needed files.
    def create
      in_outputdir do
        raise("Please use a specific Condom class, not Base.")
      end
    end

    private

    # This method creates the output directory (if needed)
    # and execute the block given in parameter.
    def in_outputdir
      # Verify output
      FileUtils.makedirs @outputdir
      raise(ArgumentError, "A block should be given") unless block_given?

      Dir.chdir @outputdir do
        raise("#{@outputdir}: it already exists a main.tex file") if File.exist? "main.tex"
        raise("#{@outputdir}: it already exists a Makefile") if File.exist? "Makefile"

        # Call the given instructions block
        yield
      end
    end

    # This fonction writes a file from its template
    def build template
      erb = File.read(File.join(VIEWS_DIR, template + ".erb"))
      content = ERB.new(erb).result(binding)
      File.open(template, 'w') do |f|
        f.write content.gsub(/\n\n\n+/, "\n\n")
      end
    end
  end
end
