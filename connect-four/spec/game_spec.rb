# frozen_string_literal: true

require_relative '../lib/game'

describe Game do
  shared_context 'when filled with some discs but without winner', :partially_filled do
    before do
      subject.make_move(1, 0)
      subject.make_move(1, 1)
      subject.make_move(2, 0)
      subject.make_move(1, 1)
      subject.make_move(3, 0)
      subject.make_move(3, 1)
      subject.make_move(4, 0)
      subject.make_move(1, 1)
      subject.make_move(3, 0)
      subject.make_move(0, 1)
      subject.make_move(6, 0)
      subject.make_move(6, 1)
      subject.make_move(5, 0)
    end
  end

  shared_context 'when having a vertical winning row', :vertically_won do
    let(:winner) { 0 }
    before do
      subject.make_move(1, winner)
      subject.make_move(1, 1)
      subject.make_move(2, winner)
      subject.make_move(1, 1)
      subject.make_move(3, winner)
      subject.make_move(3, 1)
      subject.make_move(4, winner)
      subject.make_move(1, 1)
      subject.make_move(3, winner)
      subject.make_move(0, 1)
      subject.make_move(6, winner)
      subject.make_move(6, 1)
      subject.make_move(5, winner)
      subject.make_move(3, winner)
      subject.make_move(3, winner)
      subject.make_move(3, winner)
    end
  end

  shared_context 'when having a horizontal winning row', :horizontally_won do
    let(:winner) { 1 }
    before do
      subject.make_move(1, 0)
      subject.make_move(2, winner)
      subject.make_move(2, winner)
      subject.make_move(3, 0)
      subject.make_move(3, winner)
      subject.make_move(4, 0)
      subject.make_move(4, winner)
      subject.make_move(5, 0)
      subject.make_move(5, winner)
    end
  end

  shared_context 'when having a diagonal winning row', :diagonally_won do
    let(:winner) { 1 }
    before do
      subject.make_move(1, 0)
      subject.make_move(2, winner)
      subject.make_move(3, 0)
      subject.make_move(3, winner)
      subject.make_move(4, 0)
      subject.make_move(4, 0)
      subject.make_move(4, winner)
      subject.make_move(5, 0)
      subject.make_move(5, 0)
      subject.make_move(5, 0)
      subject.make_move(5, winner)
    end
  end

  shared_context 'when filled completely without a winning row', :draw do
    before do
      (0...6).each do |_row|
        (0...7).each do |col|
          subject.make_move(col)
          subject.change_player
        end
      end
    end
  end

  shared_context 'when filled completely with a winning row', :filled_and_won do
    before do
      (0...5).each do |_row|
        (0...7).each do |col|
          game.make_move(col)
          game.change_player
        end
      end
    end
    game.make_move(0, 0)
    game.make_move(1, 0)
    game.make_move(2, 0)
    game.make_move(3, 0)
    game.make_move(4, 1)
    game.make_move(5, 1)
    game.make_move(6, 1)
  end

  describe '#make_move' do
    it 'adds to the column, to which a disc was added', :partially_filled do
      column = 3
      player = 0
      from = subject.columns[column].dup
      to = [*from, player]
      expect { subject.make_move(column, player) }
        .to change { subject.columns[column] }
        .from(from)
        .to(to)
    end
  end

  describe '#won?' do
    it 'returns false if winner is nil' do
      allow(subject).to receive(:winner).and_return(nil)
      expect(subject.won?).to eq(false)
    end

    it 'returns true if winner is a winner_symbol ' do
      allow(subject).to receive(:winner).and_return('☺')
      expect(subject.won?).to eq(true)
    end
  end

  describe 'winner' do
    it 'returns nil at the beginning' do
      expect(subject.winner).to eq nil
    end

    it 'returns nil', :partially_filled do
      expect(subject.winner).to eq nil
    end

    it 'returns the winner symbol', :vertically_won do
      expect(subject.winner).to eq subject.player_symbols[winner]
    end

    it 'returns the winner symbol', :horizontally_won do
      expect(subject.winner).to eq subject.player_symbols[winner]
    end

    it 'returns the winner symbol', :diagonally_won do
      expect(subject.winner).to eq subject.player_symbols[winner]
    end

    it 'returns nil', :draw do
      expect(subject.winner).to eq nil
    end
  end

  describe '#draw?' do
    it 'returns false at the beginning' do
      expect(subject.draw).to eq false
    end

    it 'returns false', :partially_filled do
      expect(subject.draw).to eq false
    end

    it 'returns false', :horizontally_won do
      expect(subject.draw).to eq false
    end

    it 'returns true', :draw do
      expect(subject.draw).to eq true
    end

    it 'returns false', :filled_and_won do
      expect(subject.draw).to eq false
    end
  end

  describe '#change_player' do
    it 'changes the player from 0 to 1 at the beginning' do
      expect { subject.change_player }
        .to change { subject.current_player }
        .from(0).to(1)
    end

    it 'changes the player from 1 to 0 if the player is 1' do
      subject.current_player = 1
      expect { subject.change_player }
        .to change { subject.current_player }
        .from(1).to(0)
    end

    it 'the player does not change when calling it two times' do
      expect { 2.times(subject.change_player) }
        .not_to.change { subject.current_player }
    end
  end

  describe '#valid_columns' do
    it 'returns all columns at the beginning' do
      expect(subject.valid_columns).to eq [0, 1, 2, 3, 4, 5, 6]
    end

    it 'returns all columns if no column is full', :partially_filled do
      expect(subject.valid_columns).to eq [0, 1, 2, 3, 4, 5, 6]
    end

    it 'returns returns the remaining columns after one column was filled' do
      subject.make_move(1, 0)
      subject.make_move(1, 1)
      subject.make_move(1, 0)
      subject.make_move(1, 1)
      subject.make_move(1, 0)
      subject.make_move(1, 1)
      expect(subject.valid_columns).to eq [0, 2, 3, 4, 5, 6]
    end

    it 'returns returns the remaining columns after three columns were filled' do
      [0, 4, 5].each do |col|
        subject.make_move(col, 0)
        subject.make_move(col, 1)
        subject.make_move(col, 0)
        subject.make_move(col, 1)
        subject.make_move(col, 0)
        subject.make_move(col, 1)
      end
      expect(subject.valid_columns).to eq [1, 2, 3, 6]
    end

    it 'returns an empty array after all columns were filled', :draw do
      expect(subject.valid_columns).to eq []
    end
  end

  describe '#valid_column?' do
    it 'returns true for all #valid_columns' do
      columns = [1, 3, 5]
      allow(subject).to receive(:valid_columns).and_return(columns)
      columns.each { |col| expect(subject.valid_column?(col)).to be true }
    end

    it 'returns false for everything not in #valid_columns' do
      columns = [2, 3, 4, 7]
      invalid = [1, 5, 6]
      allow(subject).to receive(:valid_columns).and_return(columns)
      invalid.each { |col| expect(subject.valid_column?(col)).to be false }
    end

    it 'returns false for everything not a number' do
      expect(subject.valid_column?('a')).to be false
    end

    it 'returns false for any number, if #valid_columns is empty' do
      columns = []
      invalid = [1, 2, 3, 4, 5, 6, 7]
      allow(subject).to receive(:valid_columns).and_return(columns)
      invalid.each { |col| expect(subject.valid_column?(col)).to be false }
    end
  end
end
