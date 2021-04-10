# frozen_string_literal: true

# pretty output for connect four game
class GamePrinter
  def initialize(game)
    @game = game
  end

  def to_s
    @game
      .max_row.downto(0)
      .map { |i_row| @game.columns.map { |col| col[i_row] } }
      .map { |row| row.map { |el| el ? @game.player_symbols[el] : ' ' } }
      .map { |row| "║ #{row.join(' │ ')} ║\n" }
      .join("╟───┼───┼───┼───┼───┼───┼───╢\n") +
      '╚═══╧═══╧═══╧═══╧═══╧═══╧═══╝'
  end

  def print
    puts to_s
  end
end
