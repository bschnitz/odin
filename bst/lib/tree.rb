# frozen_string_literal: true

require_relative 'node'

# binary search tree
class Tree
  # @param values [Array]
  def initialize(values)
    @root = build_tree(values.sort.uniq)
  end

  # @param values [Array] must be sorted and have no duplicates
  # @param left [Integer] index of leftmost value to be inserted
  # @param right [Integer] index of rightmost value to be inserted
  #
  # @return [Node] the root of the new tree
  def build_tree(values, left = 0, right = values.length - 1)
    return nil if right < left

    mid = left + (right - left + 1) / 2
    root = Node.new(values[mid])
    root.insert(build_tree(values, left, mid - 1))
    root.insert(build_tree(values, mid + 1, right))

    root
  end

  def insert(value)
    @root.insert(Node.new(value))
  end

  def delete(value)
    node = Node.new(value)
    @root = nil if !@root.delete(node) && node == @root
  end

  def find(value)
    @root.find_inverse_path(Node.new(value)).first
  end

  def print
    return if @root.nil?

    @root.flatten_tree.each do |level|
      puts level
    end
  end

  def inorder
    @root.inorder.map(&:data)
  end

  def preorder
    @root.preorder.map(&:data)
  end

  def postorder
    @root.postorder.map(&:data)
  end

  def level_order
    @root.level_order.map(&:data)
  end

  def height
    @root.height
  end

  def depth(value)
    @root.find_inverse_path(Node.new(value)).to_a.length - 1
  end

  def balanced?
    @root.balanced? ? true : false
  end

  def rebalance
    @root = build_tree(inorder)
  end
end
