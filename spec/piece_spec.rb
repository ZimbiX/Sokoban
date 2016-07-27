require 'require_all'
require_rel './spec_helper.rb'

describe Piece do
  it "piece types have correct solidity" do
    Player.new.solid?.must_equal true
    Wall.new.solid?.must_equal true
    Box.new.solid?.must_equal true
    Goal.new.solid?.must_equal false
  end
end
