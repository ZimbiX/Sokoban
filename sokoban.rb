#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'require_all'
require_rel 'app'

if __FILE__ == $0
  ConsoleView.new
end