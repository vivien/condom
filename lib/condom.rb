#!/usr/bin/ruby -w

#TODO Split author with space to get firstname and lastname?

require 'etc'
require 'erb'
require 'fileutils'

# The Condom module
module Condom
  VERSION = 2.0
  VIEWS_DIR = File.join(File.expand_path(File.dirname(__FILE__)), '..', 'views')

  def Condom.get_user_name
    user = Etc.getpwnam(Etc.getlogin)['gecos'].split(',').first
    user = Etc.getlogin if user.nil?

    return user
  end

  class Document
    attr_accessor :outputdir,
      :listings, :fancyhdr, :graphics, :math, :pdf,
      :filename, :author, :title, :date, :document_class,
      :packages

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

    def get_options
      hash = Hash.new
      instance_variables.each do |var|
        hash[var[1..-1].to_sym] = instance_variable_get(var)
      end

      return hash
    end

    def set_options(hash)
      hash.keys.each do |key|
        var = '@' << key.to_s
        raise("Key #{key} not supported.") unless instance_variables.include? var
        instance_variable_set(var, hash[key])
      end
    end

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
