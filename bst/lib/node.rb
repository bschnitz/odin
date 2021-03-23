# frozen_string_literal: true

# node in a binary search tree
class Node
  include Comparable

  attr_reader :data, :left, :right

  def <=>(other)
    @data <=> other.data
  end

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end

  # @param node [Node]
  # @return [Node]
  def insert(node)
    return nil if node.nil?

    return @right&.insert(node) || @right = node if node > self

    return @left&.insert(node)  || @left = node  if node < self

    node
  end

  def both_childs?
    !@left.nil? && !@right.nil?
  end

  def any_child?
    !@left.nil? || !@right.nil?
  end

  def no_childs?
    @left.nil? && @right.nil?
  end

  def delete_smallest_decendent
    if @left
      if @left.no_childs?
        data = @left.data
        @left = nil
      else
        data = @left.delete_smallest_decendent
      end
    elsif @right
      data = @data
      replace_by_right
    end

    data
  end

  def replace_by_node(node)
    @data = node.data
    @left = node.left
    @right = node.right
  end

  def replace_by_left
    return false if @left.nil?

    if @left.no_childs?
      @data = @left.data
      @left = nil
      true
    elsif @right.nil?
      replace_by_node(@left)
      true
    else false end
  end

  def replace_by_right
    return false if @right.nil?

    if @right.no_childs?
      @data = @right.data
      @right = nil
      true
    elsif @left.nil?
      replace_by_node(@right)
      true
    else false end
  end

  # searches a decendent which can replace this node. the value from the
  # replacement is copied into this node and the decendent is deleted
  # @return false if no child for replacement exists, true else
  def replace_by_decendent
    return false unless any_child?

    return true if replace_by_right || replace_by_left

    @data = @right.delete_smallest_decendent

    true
  end

  # deletes child, if it is a child of self
  # @return [Boolean] false if child is not a child of self, else true
  def delete_child(child)
    if @left == child
      @left = nil
      true
    elsif @right == child
      @right = nil
      true
    end

    false
  end

  # @param node [Node]
  # @param parent [Node|nil]
  # deletes node if it is a decendent from self or parent, if node == self and
  # parent is nil, node cannot be deleted
  # @return [Boolean] true if node could be found and deleted, false else
  def delete(node, parent = nil)
    return @right&.delete(node, self) if node > self

    return @left&.delete(node, self)  if node < self

    replace_by_decendent || parent&.delete_child(self) || false
  end

  def childs
    [@left, @right]
  end

  def to_s
    @data.to_s
  end

  def filled_zip(array1, array2)
    array1[array2.length - 1] = nil if array1.length < array2.length
    array1.zip(array2)
  end

  def merge_flattened_top(left, right, position)
    case position
    when :left
      "#{' ' * left.length}#{self}#{'━' * right.length}"
    when :right
      "#{'━' * left.length}#{self}#{' ' * right.length}"
    else
      "#{' ' * left.length}#{self}#{' ' * right.length}"
    end
  end

  def merge_flattened_child_level(left, right)
    pad = '━' * (to_s.length - 1)

    if both_childs? then "#{left}┻#{pad}#{right}"
    elsif @right    then "#{left}┗#{pad}#{right}"
    elsif @left     then "#{left}#{pad}┛#{right}"
    end
  end

  def merge_flattened_sub_child_levels(levels)
    mid = ' ' * to_s.length
    left_pad, right_pad = levels.shift.map { |entry| ' ' * entry.length }
    levels.map do |lr|
      "#{lr[0] || left_pad}#{mid}#{lr[1] || right_pad}"
    end
  end

  def merge_flattened(flat_left, flat_right, position)
    return [to_s] if no_childs?

    flat_left  ||= ['']
    flat_right ||= ['']

    top = merge_flattened_top(flat_left[0], flat_right[0], position)

    levels = filled_zip(flat_left, flat_right)
    level1 = merge_flattened_child_level(*(levels[0]))

    merge_flattened_sub_child_levels(levels).unshift(top, level1)
  end

  def flatten_tree(position = nil)
    merge_flattened(
      @left&.flatten_tree(:left),
      @right&.flatten_tree(:right),
      position
    )
  end

  def find_inverse_path(node)
    Enumerator.new do |yielder|
      if node < self
        @left&.find_inverse_path(node)&.each { |child| yielder << child }
      elsif node > self
        @right&.find_inverse_path(node)&.each { |child| yielder << child }
      end
      yielder << self
    end
  end

  def inorder
    Enumerator.new do |yielder|
      @left&.inorder&.each { |node| yielder << node }
      yielder << self
      @right&.inorder&.each { |node| yielder << node }
    end
  end

  def postorder
    Enumerator.new do |yielder|
      @left&.postorder&.each { |node| yielder << node }
      @right&.postorder&.each { |node| yielder << node }
      yielder << self
    end
  end

  def preorder
    Enumerator.new do |yielder|
      yielder << self
      @left&.preorder&.each { |node| yielder << node }
      @right&.preorder&.each { |node| yielder << node }
    end
  end

  def level_order(level = [self])
    Enumerator.new do |yielder|
      level = level.each_with_object([]) do |node, new_level|
        yielder << node
        new_level.push(node.left) if node.left
        new_level.push(node.right) if node.right
      end
      level_order(level).each { |node| yielder << node } unless level.empty?
    end
  end

  def height
    return 0 if no_childs?

    [@left&.height || 0, @right&.height || 0].max + 1
  end

  # @return [Boolean|Integer] false if not balanced, the height otherwise
  def balanced?
    return 0 if no_childs?

    height_l = @left.nil?  ? 0 : @left.balanced?
    height_r = @right.nil? ? 0 : @right.balanced?

    return false unless height_l && height_r

    (height_l - height_r).abs < 2 && ([height_l, height_r].max + 1)
  end
end
