# frozen_string_literal: true

require 'set'

class KnightTravailsGame
  BOARD_WIDTH = 8

  POSSIBLE_MOVE_DELTAS = [-1, 1].product([2, -2]) + [-2, 2].product([1, -1])

  def knight_moves(from_field, to_field)
    raise 'Invalid fields provided to knight_moves' if
      !valid_field?(*from_field) || !valid_field?(*to_field)

    shortest = search_by_extending_pathes([[from_field]], to_field)
    puts "=> You made it in #{shortest.length - 1} moves!  Here's your path:"
    p shortest
  end

  def valid_field?(pos_x, pos_y)
    pos_x.between?(0, BOARD_WIDTH) && pos_y.between?(0, BOARD_WIDTH)
  end

  private

  def extend_path(path, move_delta, visited)
    new_field = [path[-1][0] + move_delta[0], path[-1][1] + move_delta[1]]

    return false if !valid_field?(*new_field) || visited.include?(new_field)

    path + [new_field]
  end

  def search_by_extending_pathes(pathes, to_field, visited = Set[])
    loop do
      pathes = pathes.each_with_object([]) do |path, new_pathes|
        POSSIBLE_MOVE_DELTAS.each do |delta|
          next unless (new_path = extend_path(path, delta, visited))

          return new_path if new_path[-1] == to_field

          new_pathes << new_path
          visited << [new_path[-1]]
        end
      end
    end
  end
end

game = KnightTravailsGame.new

game.knight_moves([0, 0], [1, 2])
game.knight_moves([0, 0], [3, 3])
game.knight_moves([3, 3], [0, 0])
game.knight_moves([3, 3], [8, 8])
