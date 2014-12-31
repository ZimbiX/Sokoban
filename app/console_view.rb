class ConsoleView
  def initialize
    @current_level_number = 1
    load_level
    @directions = {
      'w' => UP,
      'a' => LEFT,
      's' => DOWN,
      'd' => RIGHT,
    }
    run
  end

  def load_level
    @level = Level.new @current_level_number
  end

  def move direction
    @level.board.player.move direction
  end

  def interpret_command command_str
    if @directions.include? command_str
      move @directions[command_str]
    else
      case command_str
      when 'r' then load_level
      end
    end
  end

  def run
    puts @directions.inspect
    loop do
      puts '', @level.board
      print "\nEnter move direction: "
      command = STDIN.getc.chomp
      puts "Your response: " + command.inspect
      interpret_command command
      break if command == 'q'
    end
  end
end
