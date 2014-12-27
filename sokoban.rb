#!/usr/bin/env ruby

require './setup'
require './piece'
require './board'
require './tile'
require './player'
require './box'
require './goal'

if __FILE__ == $0
  tile1 = Tile.new
  tile2 = Tile.new '$'
  tile3 = Tile.new '8'
  puts tile1, tile2, tile3

  player = Player.new Tile.new
  puts player.to_s

  board = Board.new 8, 10
  puts board.to_s
end