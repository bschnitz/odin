# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/game_printer'

describe GamePrinter do
  let(:game) do
    instance_double(
      Game,
      columns: [[], [], [], [], [], [], []],
      player_symbols: ['☺', '☻'],
      max_row: 5
    )
  end

  subject { GamePrinter.new(game) }

  describe '#to_s' do
    it 'returns an empty game at the beginning' do
      expect(subject.to_s).to eq(
        "║   │   │   │   │   │   │   ║\n" \
        "╟───┼───┼───┼───┼───┼───┼───╢\n" \
        "║   │   │   │   │   │   │   ║\n" \
        "╟───┼───┼───┼───┼───┼───┼───╢\n" \
        "║   │   │   │   │   │   │   ║\n" \
        "╟───┼───┼───┼───┼───┼───┼───╢\n" \
        "║   │   │   │   │   │   │   ║\n" \
        "╟───┼───┼───┼───┼───┼───┼───╢\n" \
        "║   │   │   │   │   │   │   ║\n" \
        "╟───┼───┼───┼───┼───┼───┼───╢\n" \
        "║   │   │   │   │   │   │   ║\n" \
        '╚═══╧═══╧═══╧═══╧═══╧═══╧═══╝'
      )
    end

    it 'returns a partially filled game after some moves' do
      columns = [[0, 1, 0], [1, 0], [0, 1], [0, 1], [1], [], []]
      allow(game).to receive(:columns).and_return(columns)
      expect(subject.to_s).to eq(
        "║   │   │   │   │   │   │   ║\n" \
        "╟───┼───┼───┼───┼───┼───┼───╢\n" \
        "║   │   │   │   │   │   │   ║\n" \
        "╟───┼───┼───┼───┼───┼───┼───╢\n" \
        "║   │   │   │   │   │   │   ║\n" \
        "╟───┼───┼───┼───┼───┼───┼───╢\n" \
        "║ ☺ │   │   │   │   │   │   ║\n" \
        "╟───┼───┼───┼───┼───┼───┼───╢\n" \
        "║ ☻ │ ☺ │ ☻ │ ☻ │   │   │   ║\n" \
        "╟───┼───┼───┼───┼───┼───┼───╢\n" \
        "║ ☺ │ ☻ │ ☺ │ ☺ │ ☻ │   │   ║\n" \
        '╚═══╧═══╧═══╧═══╧═══╧═══╧═══╝'
      )
    end
  end
end
