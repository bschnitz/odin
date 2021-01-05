# frozen_string_literal: true

require_relative 'printer'
require_relative 'game_status'

# Controls the game and it's parts
class Game
  def initialize
    @file_with_words = 'data/5desk.txt'
    @printer = Printer.new
    @game_status = GameStatus.new(choose_word)

    welcome_and_initialize
    game_loop
  end

  def welcome_and_initialize
    puts 'Welcome to Hangman'
    puts 'Do You want to (l)oad a new game or begin a (n)ew one?'
    loop do
      input = gets.chomp
      %w[l load].include?(input) && (@game_status.load or
        puts 'No savegame exists, starting new game.')
      break if %w[l load n new].include?(input)

      puts 'Unexpected input, please type "load" or "new".'
    end
  end

  def game_loop
    @printer.print(@game_status)

    loop do
      puts 'Guess a character (a-z).'
      puts 'Type save to "save" the game and "quit" to quit.'
      return if (choice = gets.chomp) == 'quit'
      break if process_user_choice(choice)
    end

    puts @game_status.won? ? 'You won!' : 'You lost!'

    puts "\nThe word is #{@game_status.word}."
  end

  def process_user_choice(choice)
    if choice == 'save'
      @game_status.save
      puts 'Game saved.'
      false
    else
      @game_status.guess(choice[0])
      @printer.print(@game_status)
      @game_status.number_of_guesses_left.zero? || @game_status.won?
    end
  end

  def choose_word
    words = []

    File.open @file_with_words do |file|
      file.each do |line|
        word = line.chomp
        words.push(word) if word.length.between?(5, 12)
      end
    end

    words.sample
  end
end
