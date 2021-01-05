# frozen_string_literal: true

# prints the hangman and the letters of the word, which were correctly guessed
# and blanks, where a letter was not yet guessed
class Printer
  def initialize
    @graphics = File.read('data/hangman.txt').split(/^$\n/).reverse
  end

  def print(game_status)
    puts @graphics[[game_status.number_of_guesses_left, 0].max]

    letters = game_status.word.chars.map do |char|
      game_status.guessed_letters.include?(char) ? char : '_'
    end

    puts letters.join

    puts "Guesses left: #{game_status.number_of_guesses_left}"
  end
end
