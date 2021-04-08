# frozen_string_literal: true

require_relative '../lib/connect_four'
require_relative '../lib/game_printer'
require_relative '../lib/game'

describe ConnectFour do
  let(:game) do
    instance_double(
      Game,
      won?: false,
      draw?: false,
      change_player: nil,
      make_move: nil
    )
  end

  let(:game_printer) { instance_double(GamePrinter, print: nil) }

  subject { ConnectFour.new(game, game_printer) }

  describe '#game_loop' do
    before do
      allow(game).to receive(:won?).and_return(false, false, true)
    end

    it 'stops looping when the game finally is won' do
      allow(game).to receive(:won?).and_return(false, false, true)
      expect(subject).to receive(:draw?).exactly(3).times
      subject.game_loop
    end

    it 'stops looping when the game finally becomes a draw' do
      allow(game).to receive(:draw?).and_return(false, false, true)
      expect(subject).to receive(:won?).exactly(3).times
      subject.game_loop
    end

    it 'stops looping when #user_input finally becomes nil' do
      allow(subject).to receive(:user_input).and_return(0, 0, nil)
      expect(subject).to receive(:user_input).exactly(3).times
      subject.game_loop
    end

    # outgoing command to game.change_player
    it 'updates the player on each loop' do
      expect(board).to receive(:change_player).exactly(2).times
      subject.game_loop
    end

    # outgoing command to game.make_move
    it 'makes a move on each loop' do
      expect(board).to receive(:make_move).exactly(2).times
      subject.game_loop
    end

    # outgoing command to game_printer.print
    it 'prints the game on each loop' do
      expect(board_printer).to receive(:print).exactly(2).times
      subject.game_loop
    end
  end

  describe '#user_input' do
    before do
      allow(subject).to receive(:gets)
    end

    it 'returns nil, if user inputs "Q" or "q"' do
      allow(subject).to receive(:puts).and_return('Q')
      expect(subject.user_input).to be nil

      allow(subject).to receive(:puts).and_return('q')
      expect(subject.user_input).to be nil
    end

    # outgoing command: game.valid_input?
    it 'checks that input is valid' do
      allow(game).to receive(:valid_input?).and_return(false, false, true)
      expect(subject).to receive(:valid_input?).exactly(3).times
      subject.user_input
    end

    it 'requests new input until input is valid' do
      allow(game).to receive(:valid_input?).and_return(false, false, true)
      expect(subject).to receive(:gets).exactly(3).times
      subject.user_input
    end

    it 'returns the input when it is valid' do
      allow(game).to receive(:valid_input?).and_return(0)
      expect(subject).to be 0
    end
  end
end
