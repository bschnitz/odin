# frozen_string_literal: true

require_relative 'lib/tree'

t = Tree.new([1, 9, 4, 5, 7, 34, 99, 101, 3, 55])
t.print
puts "Balanced: #{t.balanced?}"
t.insert(200)
t.insert(300)
t.insert(400)
t.insert(500)
t.insert(12)
t.insert(1)
t.insert(8)
t.insert(11)
t.insert(10)
t.print
puts "Balanced: #{t.balanced?}"

puts 'Delete 500'
t.delete(500)
t.print
puts 'Delete 300'
t.delete(300)
t.print
puts 'Delete 9'
t.delete(9)
t.print
puts 'Delete 55'
t.delete(55)
t.print
puts 'Delete 55'
t.delete(55)
t.print
puts 'Delete 7'
t.delete(7)
t.print

puts 'Traversel inorder, preorder, postorder, level_order'
p t.inorder
p t.preorder
p t.postorder
p t.level_order

puts 'Find 200'
p t.find(200)

puts 'Depth 200'
p t.depth(200)

puts "Height: #{t.height}"

t.print
puts "Balanced: #{t.balanced?}"

t.rebalance
puts "Balanced: #{t.balanced?}"
t.print
