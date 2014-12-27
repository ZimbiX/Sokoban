require File.expand_path '../spec_helper.rb', __FILE__

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
end
