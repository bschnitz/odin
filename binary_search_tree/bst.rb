# frozen_string_literal: true

def center(string, pad_size, pad_left, pad_right)
  pad_size_right = (pad_size - string.length) / 2 + string.length
  string = string.rjust(pad_size_right, pad_right)
  string.ljust(pad_size, pad_left)
end

# a node of the binary search tree
class Node
  include Comparable

  attr_accessor :left, :right, :data, :height

  def initialize(data)
    @left = nil
    @right = nil
    @data = data
  end

  def <=>(other)
    data <=> other.data
  end

  def to_s(pad = 0, position = :middle)
    pad_left = position == :left ? '─' : ' '
    pad_right = position == :right ? '─' : ' '
    center(@data.to_s, pad, pad_left, pad_right)
  end

  def child_join_str
    if right && left
      '┴'
    elsif left
      '╯'
    elsif right
      '╰'
    else
      ' '
    end
  end

  def height
    return 0 unless left || right

    [left&.height || 0, right&.height || 0].max + 1
  end
end

# A binary search tree
class Tree
  def initialize(array = [])
    @root = build_tree(array)
  end

  def build_tree(array)
    build_tree_from_normalized_array(array.sort.uniq)
  end

  def build_tree_from_normalized_array(array)
    return nil if array.empty?

    middle = array.size >> 1
    root = Node.new(array[middle])
    root.left = build_tree_from_normalized_array(array[0...middle])
    root.right = build_tree_from_normalized_array(array[middle + 1..-1])

    root
  end

  def depth_first_enumerator(node)
    Enumerator.new do |out|
      out << node unless node.nil?
      node.left && depth_first_enumerator(node.left).each { |n| out << n }
      node.right && depth_first_enumerator(node.right).each { |n| out << n }
    end
  end

  def max_output_length(node = @root)
    depth_first_enumerator(node).reduce(0) do |max, it_node|
      [it_node.data.to_s.length, max].max
    end
  end

  def to_as(node = @root, pad = nil, position = :middle, trh = @root.height)
    pad ||= max_output_length(node)

    return [(node&.to_s(pad, position) || '').center(pad)] unless
      node && trh.positive?

    left = to_as(node.left, pad, :left, trh - 1)
    right = to_as(node.right, pad, :right, trh - 1)

    joined = left.zip([node.child_join_str], right).map(&:flatten)
    joined = [joined[0]] unless trh.positive?
    joined.map! { |level| level.map { |el| el || ' ' }.join('') }

    [node.to_s(joined[0].length, position)] + joined
  end

  #def level_enumerator(root = @root)
  #  Enumerator.new do |out|
  #    current_level = [root]
  #    next_level = []
  #    while current_level.any?
  #      out << current_level
  #      current_level.each do |node|
  #        next_level.push(node.left, node.right) unless node.nil?
  #      end
  #      current_level = next_level
  #      next_level = []
  #    end
  #  end
  #end

  #def breadth_first_enumerator
  #  Enumerator.new do |out|
  #    level_enumerator.each do |nodes|
  #      nodes.each { |node| out << node }
  #    end
  #  end
  #end
end

#puts Tree.new([
#  0, 8, 3, 4, 9, 20, 13, 300, 343,
#  23_434, 234_324, 324_324, 324_325
#]).to_as
#
#puts Tree.new([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]).to_as
#
tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
puts tree.to_as
