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

  def balanced?
    
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

  def find(value)
    @root.find_inverse_path(Node.new(value)).first
  end

  def print
    return if @root.nil?

    flattened = @root.flatten_tree
    flattened[:levels].each do |level|
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
