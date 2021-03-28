# frozen_string_literal: true

require_relative '../lib/calculator'

describe Calculator do
  describe '#add' do
    it 'returns the sum of two numbers' do
      calculator = Calculator.new
      expect(calculator.add(5, 2)).to eql(7)
    end

    it 'returns the sum of more than two numbers' do
      calculator = Calculator.new
      expect(calculator.add(2, 5, 7)).to eql(14)
    end
  end

  describe '#divide' do
    it 'returns the decimal fraction of two numbers' do
      calculator = Calculator.new
      expect(calculator.divide(3, 2)).to eql(1.5)
    end
  end
end
