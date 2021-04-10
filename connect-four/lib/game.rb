# frozen_string_literal: true

# backend of the connect four game, handling all logic
class Game
  attr_reader :player_symbols, :max_row
  attr_accessor :columns, :current_player

  def initialize
    @player_symbols = ['☺', '☻']
    @columns = [[], [], [], [], [], [], []]
    @max_col = @columns.length - 1
    @max_row = 5
    @current_player = 0
    @col_last_move = nil
    @winning_length = 4
  end

  def make_move(column, player = current_player)
    @columns[column].push(player)
    @col_last_move = column
  end

  def winner
    return unless @col_last_move

    diagonal_winner || horizontal_winner || vertical_winner
  end

  def won?
    winner ? true : false
  end

  def draw?
    @columns.all? { |col| col.length == @max_row + 1 } && !won?
  end

  def change_player
    @current_player = (@current_player + 1) % 2
  end

  def valid_columns
    (0..@max_col).filter { |col| @columns[col].length < @max_row + 1 }
  end

  def valid_column?(index)
    return false if index.is_a?(String) && index.to_i.to_s != index

    valid_columns.include?(index.to_i)
  end

  private

  def winner_of_row(row)
    row
      .slice_when { |el_before, el_current| el_before != el_current }
      .select { |element| element.length >= @winning_length }
      .first&.first
  end

  def extract_cells(&block)
    res = []

    (0..@max_row).map do |i_row|
      (0..@max_col).map do |i_col|
        res.push(@columns[i_col][i_row]) if block.call(i_row, i_col)
      end
    end

    res
  end

  def diagonal_winner
    i_row_last_move = @columns[@col_last_move].length - 1

    # extract diagonal from bottom to top through last move
    delta = @col_last_move - i_row_last_move
    diag1 = extract_cells { |i_row, i_col| i_col - i_row == delta }

    # extract diagonal from top to bottom through last move
    delta = (@max_col - @col_last_move) - i_row_last_move
    diag2 = extract_cells { |i_row, i_col| (@max_col - i_col) - i_row == delta }

    winner_of_row(diag1) || winner_of_row(diag2)
  end

  def horizontal_winner
    i_row_last_move = @columns[@col_last_move].length - 1
    winner_of_row(extract_cells { |i_row, _| i_row == i_row_last_move })
  end

  def vertical_winner
    winner_of_row(extract_cells { |_, i_col| i_col == @col_last_move })
  end
end
