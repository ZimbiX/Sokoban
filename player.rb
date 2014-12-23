class Player
  def to_s
    GAME_ASCII[self.class.name.to_sym]
  end
end