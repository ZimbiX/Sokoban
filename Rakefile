#!/usr/bin/env ruby

require 'fileutils'
require 'os-name'

def appdata_path
  case OS.name
  when /Windows|cygwin/
    ENV['APPDATA']
  when 'OS X'
    File.join ENV['HOME'], 'Library', 'Application Support'
  when 'Linux'
    File.join ENV['HOME'], '.config'
  end
end

# Make a list of paths containing the packages folder of each Sublime Text installation
def sublime_text_packages_folders
  ['Sublime Text']
    .flat_map { |s| [s, s+' 2', s+' 3'] }
    .flat_map { |s| [s, s.downcase.gsub(' ', '-')] }
    .map { |s| File.join appdata_path, s, 'Packages' }
    .select { |d| Dir.exist? d }
end

task :install_sublime_text_level_syntax do
  syntax_file_glob = File.join File.dirname(__FILE__), 'sublime-text', '*.tmLanguage'
  syntax_files = Dir[syntax_file_glob]
  sublime_text_packages_folders.map { |x| File.join x, 'User' }.each do |destination|
    puts "Installing level syntax in: #{destination}"
    FileUtils.mkdir_p destination
    FileUtils.cp syntax_files, destination
  end
end
