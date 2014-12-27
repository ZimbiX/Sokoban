require 'require_all'
require_rel './spec_helper.rb'

describe Tile do
  describe ".initialize" do
    it "creates inhabitants from char" do
      tile = Tile.new '$'
      tile.inhabitants_classes.must_equal [Player]
    end

    it "creates inhabitants from class symbol array" do
      tile = Tile.new [:Box, :Goal]
      tile.inhabitants_classes.must_equal [Box, Goal]
    end
  end

  describe ".place" do
    let(:tile) do
      Tile.new([:Goal]).tap { |tile| Box.new tile }
    end

    it "can add a second inhabitant" do
      tile.inhabitants.count.must_equal 2
    end

    it "sorts inhabitants after adding a new one" do
      tile.inhabitants_classes.must_equal [Box, Goal]
    end
  end

  describe ".take" do
    it "can remove a piece from the tile" do
      [Box, Player].each do |piece_class|
        tile = Tile.new
        piece = piece_class.new tile
        tile.inhabitants_classes.must_equal [piece_class]
        tile.take.must_equal piece
        tile.inhabitants_classes.must_equal []
      end
    end
  end
end
