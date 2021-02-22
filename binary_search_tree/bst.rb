# frozen_string_literal: true

def center(string, pad_size, pad_left, pad_right)
  pad_size_right = (pad_size - string.length) / 2 + string.length
  string = string.rjust(pad_size_right, pad_right)
  string.ljust(pad_size, pad_left)
end

# a node of the binary search tree
class Node
  include Comparable

  attr_accessor :data, :parent
  attr_reader :left, :right, :height

  def initialize(data, parent)
    @left = nil
    @right = nil
    @parent = parent
    @data = data
    @height = 0
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

  def recalculate_height
    @height = [left&.height || 0, right&.height || 0].max + 1
    @parent&.recalculate_height
  end

  def left=(node)
    @left = node
    @height = [left&.height || 0, right&.height || 0].max + 1
    node&.parent = self
  end

  def right=(node)
    @right = node
    @height = [left&.height || 0, right&.height || 0].max + 1
    node&.parent = self
  end

  def replace_child(child, replacement)
    if @left == child
      self.left = replacement
    elsif @right == child
      self.right = replacement
    end
  end

  def rotate_left
    return unless @right

    # root has no parent, thus the use of &.
    @parent&.replace_child(self, @right)
    @right.parent = @parent

    temp = @right.left
    @right.left = self
    self.right = temp

    @parent.recalculate_height
  end

  def rotate_right
    return unless @left

    # root has no parent, thus the use of &.
    @parent&.replace_child(self, @left)
    @left.parent = @parent

    temp = @left.right
    @left.right = self
    self.left = temp

    @parent.recalculate_height
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

  def build_tree_from_normalized_array(array, parent = nil)
    return nil if array.empty?

    middle = array.size >> 1
    node = Node.new(array[middle], parent)
    node.left = build_tree_from_normalized_array(array[0...middle], node)
    node.right = build_tree_from_normalized_array(array[middle + 1..-1], node)

    node
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

  def rotate_left(node)
    node.rotate_left
    # if root was rotated, it is no longer root, correct this!
    @root = @root.parent if @root == node
  end

  def rotate_right(node)
    node.rotate_right
    # if root was rotated, it is no longer root, correct this!
    @root = @root.parent if @root == node
  end

  def test_rotate_left
    rotate_left(@root)
  end

  def test_rotate_right
    rotate_right(@root)
  end

  # only works correltly if tree is balanced
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
tree.test_rotate_left
puts tree.to_as
tree.test_rotate_right
puts tree.to_as
tree.test_rotate_right
puts tree.to_as
