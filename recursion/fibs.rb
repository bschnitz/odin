# frozen_string_literal: true

def fibs(number)
  return [0] if number == 1

  members = [0, 1]
  (0..number - 3).each do |i|
    members.push(members[i] + members[i + 1])
  end

  members
end

p fibs(1)
p fibs(2)
p fibs(5)
p fibs(10)

def fibs_rec(number)
  return [0] if number == 1

  previous = fibs_rec(number - 1)
  [*previous, (previous[-1] || 0) + (previous[-2] || 1)]
end

p fibs_rec(1)
p fibs_rec(2)
p fibs_rec(5)
p fibs_rec(10)
