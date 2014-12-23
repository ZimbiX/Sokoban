#!/usr/bin/env ruby

require './setup'
require './board'
require './player'

if __FILE__ == $0
  player = Player.new
  puts player.to_s
end