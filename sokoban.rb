#!/usr/bin/env ruby

require './setup'
require './piece'
require './board'
require './tile'
require './player'
require './box'
require './goal'

if __FILE__ == $0
  tile = Tile.new
  player = Player.new Tile.new
  puts player.to_s
end