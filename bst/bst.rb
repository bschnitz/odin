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
        data = @left.delete_smallest_decendent(self)
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
  # @return [Boolean] true if node could be found and deleted, false els
  def delete(node, parent = nil)
    return @right&.delete(node, self) if node > self

    return @left&.delete(node, self)  if node < self

    replace_by_decendent || parent&.delete_child(self)
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

  def merge_flattened(flat_left, flat_right, position)
    return { width: to_s.length, levels: [to_s] } if no_childs?

    flat_left  ||= { width: 0, levels: [''] }
    flat_right ||= { width: 0, levels: [''] }

    left_width = flat_left[:width]
    right_width = flat_right[:width]

    case position
    when :left
      pad_left = ' '
      pad_right = '━'
    when :right
      pad_left = '━'
      pad_right = ' '
    else
      pad_left = ' '
      pad_right = ' '
    end

    top = "#{pad_left * left_width}#{self}#{pad_right * right_width}"

    mid = if both_childs? then "┻#{'━' * (to_s.length - 1)}"
          elsif @right    then "┗#{'━' * (to_s.length - 1)}"
          elsif @left     then "#{'━' * (to_s.length - 1)}┛"
          end

    levels = filled_zip(flat_left[:levels], flat_right[:levels])
    level1 = levels.shift
    level1 = "#{level1[0] || '' * left_width}#{mid}#{level1[1] || '' * right_width}"

    mid = ' ' * to_s.length
    levels.map! do |lr|
      "#{lr[0] || ' ' * left_width}#{mid}#{lr[1] || ' ' * right_width}"
    end

    {
      width: top.length,
      levels: levels.unshift(top, level1)
    }
  end

  def flatten_tree(position = nil)
    merge_flattened(
      @left&.flatten_tree(:left),
      @right&.flatten_tree(:right),
      position
    )
  end
end

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
    return nil if right <= left

    values = values.sort.uniq

    mid = left + (right - left) / 2
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

  def print
    flattened = @root.flatten_tree
    flattened[:levels].each do |level|
      puts level
    end
  end
end

t = Tree.new([1, 9, 4, 5, 7, 34, 99, 101, 3, 55])
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
