# frozen_string_literal: true

class Calculator
  def add(*numbers)
    numbers.reduce(&:+)
  end

  def divide(a, b)
    return a.to_f / b
  end
end
