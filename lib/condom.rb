# Condom, a Ruby lib for LaTeX document.
#
# Author:: Vivien 'v0n' Didelot <vivien.didelot@gmail.com>
# See:: http://github.com/v0n/condom

# TODO Use a Rakefile instead of a Makefile
# TODO Add 'tar' and 'zip' targets to the Rakefile
# TODO Add \listoffigures if graphics
# TODO Prepare a .gitignore file
# TODO Rename first-page into titlepage
# TODO Use http://en.wikibooks.org/wiki/LaTeX/Title_Creation instead of the current titlepage?
# TODO Put back the default lmodern font family
# TODO Add a README (how to compile, etc.)
# TODO Add helpers? e.g. print \lstinputlisting{...} for every files in src/.

require "condom/base"
require "condom/classic"
require "condom/presentation"
require "condom/letter"
require "condom/cv"

require "etc"

module Condom
  # Lib version
  VERSION = '2.0.1'

  # Constant views directory
  VIEWS_DIR = File.join(File.expand_path(File.dirname(__FILE__)), 'views')

  module_function

  # Function to get the name of the user.
  # It will be the name in the /etc/passwd file (on Un*x system)
  # or the system user.
  def get_user_name
    user = Etc.getpwnam(Etc.getlogin)['gecos'].split(',').first
    user = Etc.getlogin if user.nil?

    return user
  end
end
