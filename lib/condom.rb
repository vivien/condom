#!/usr/bin/ruby -w

#TODO Split author with space to get firstname and lastname?

require 'etc'
require 'erb'
require 'fileutils'

# The Condom module
module Condom
  # Constant views directory
  VIEWS_DIR = File.join(File.expand_path(File.dirname(__FILE__)), 'views')

  # Function to get the name of the user.
  # It will be the name in the /etc/passwd file (on Un*x  system)
  # or the system user.
  def Condom.get_user_name
    user = Etc.getpwnam(Etc.getlogin)['gecos'].split(',').first
    user = Etc.getlogin if user.nil?

    return user
  end

  # The Document class.
  # This is the main class of the condom lib.
  class Document
    attr_accessor :outputdir,
      :listings, :fancyhdr, :graphics, :math, :pdf,
      :filename, :author, :title, :date, :document_class,
      :packages

    # The default options
    DEFAULT_OPTIONS = {
      :outputdir      => Dir.getwd,
      :listings       => false,
      :fancyhdr       => false,
      :graphics       => false,
      :math           => false,
      :pdf            => true,
      :filename       => 'main',
      :author         => Condom.get_user_name,
      :title          => 'Document \LaTeX',
      :date           => '\today',
      :document_class => 'article',
      :packages       => Array.new
    }

    # The constructor.
    # Argument could be nothing,
    # the title of the document,
    # a hash of options.
    def initialize(*args)
      # Need to initialize each variables else they won't exist in instance_variables.
      @outputdir = @listings = @fancyhdr = @graphics = @math = @pdf = @filename = @author = @title = @date = @document_class = @packages = nil

      set_options DEFAULT_OPTIONS

      arg = args.first
      if arg.is_a? String
        @title = arg
      elsif arg.is_a? Hash
        set_options arg
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

    # This method creates the output directory (if needed)
    # and write in it all files needed.
    def create
      # Verify output
      FileUtils.makedirs @outputdir
      Dir.chdir @outputdir do
        raise("#{@outputdir}: it already exists a main.tex file") if File.exist? "main.tex"
        raise("#{@outputdir}: it already exists a Makefile") if File.exist? "Makefile"

        # Create files
        if @document_class == "beamer"
          build "main_beamer.tex"
        else
          build "main.tex"
        end
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

    private

    # This fonction writes a file from its template
    def build template
      file = (template == "main_beamer.tex") ? "main.tex" : template

      erb = File.read(File.join(VIEWS_DIR, template + ".erb"))
      content = ERB.new(erb).result(binding)
      File.open(file, 'w') do |f|
        f.write content
      end
    end
  end
end
