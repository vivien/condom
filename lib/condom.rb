require "condom/base"
require "condom/document"
require "condom/presentation"

require "etc"

module Condom
  # Lib version
  VERSION = '0.2.0'

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
