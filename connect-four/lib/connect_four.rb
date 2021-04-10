# frozen_string_literal: true

require_relative 'game'
require_relative 'game_printer'

# the main class of the game, communicates with the user and the other classes
class ConnectFour
  def initialize(game = Game.new, game_printer = GamePrinter.new(game))
    @game = game
    @game_printer = game_printer
  end

  def game_loop
    puts "Welcome to Connect Four!\n"

    @game_printer.print

    until @game.won? || @game.draw? || (move = user_input).nil?
      puts
      @game.make_move(move)
      @game_printer.print
      @game.change_player
    end

    puts "Player #{@game.winner} has won. Congratulations!" if @game.won?
    puts 'No moves left, it is a draw.'                     if @game.draw?
  end

  def user_input
    player = @game.player_symbols[@game.current_player]
    puts "Player #{@game.current_player} (#{player}) it's your move."
    loop do
      puts 'Please specify a column or enter "q"/"Q" to exit the game.'
      puts "Valid columns are #{@game.valid_columns}."
      input = gets.chop

      return if %w[q Q].include?(input)
      return input.to_i if @game.valid_column?(input)

      puts "Invalid input '#{input}', please try again."
    end
  end
end
