#!/usr/bin/env ruby

require './setup'
require './board'
require './tile'
require './player'
require './box'
require './goal'

if __FILE__ == $0
  player = Player.new
  puts player.to_s
end