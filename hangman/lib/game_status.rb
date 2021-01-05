# frozen_string_literal: true

require 'set'
require 'json'

# Current status of the hangman game, can be saved to and loaded from file
# Changed by guessing a letter
class GameStatus
  attr_reader :number_of_guesses_left, :word, :guessed_letters

  def initialize(word)
    @saves_file = 'save.json'
    @word = word
    @guessed_letters = Set[]
    @number_of_guesses_left = 10
  end

  def guess(letter)
    @guessed_letters.add(letter)
    @number_of_guesses_left -= 1 unless @word.include?(letter)
  end

  def won?
    @guessed_letters >= @word.chars.to_set
  end

  def save
    File.write(@saves_file, JSON.dump({
      word: @word,
      guessed_letters: @guessed_letters.to_a,
      number_of_guesses_left: @number_of_guesses_left
    }))
  end

  def load
    return false unless File.exist?(@saves_file)

    data = JSON.parse(File.read(@saves_file))
    @word                   = data['word']
    @guessed_letters        = data['guessed_letters'].to_set
    @number_of_guesses_left = data['number_of_guesses_left']

    true
  end
end
