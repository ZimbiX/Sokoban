LEFT  = [-1, 0]
RIGHT = [ 1, 0]
UP    = [ 0,-1]
DOWN  = [ 0, 1]

SOLID_PIECES = [:Wall, :Box]

GAME_ASCII = {
  [:Player]     => '$',
  [:Wall]       => '#',
  [:Goal]       => '-',
  [:Box]        => '0',
  [:Box, :Goal] => '8',
}