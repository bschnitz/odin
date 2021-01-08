# frozen_string_literal: true

# a node of the LinkedList
class Node
  attr_accessor :value, :next_node

  def initialize(value)
    @value = value
    @next_node = nil
  end
end

# linked list data structure for ruby
class LinkedList
  def initialize
    @pre_head = Node.new(nil)
  end

  def head
    @pre_head.next_node
  end

  def tail
    return nil if head.nil?

    pointer = head
    pointer = pointer.next_node while pointer.next_node
    pointer
  end

  def append(value)
    (tail || @pre_head).next_node = Node.new(value)
  end

  def at(index)
    pointer = @pre_head
    pointer = pointer.next_node while pointer && (index -= 1) >= -1
    pointer
  end

  def insert_at(value, index)
    node_before_index = at(index - 1)
    node_at_index = node_before_index.next_node
    node_before_index.next_node = Node.new(value)
    node_before_index.next_node.next_node = node_at_index
  end

  def prepend(value)
    insert_at(value, 0)
  end

  def remove_at(index)
    node_before_index = at(index - 1)
    node_before_index.next_node = node_before_index.next_node.next_node
  end

  def size
    size = 0
    pointer = @pre_head
    size += 1 while (pointer = pointer.next_node)
    size
  end

  def pop
    remove_at(size - 1)
  end

  def find(value)
    ptr = head
    index = 0
    while ptr.next_node && ptr.value != value
      ptr = ptr.next_node
      index += 1
    end
    ptr.value == value ? index : nil
  end

  def contains?(value)
    !find(value).nil?
  end

  def to_s
    str = String.new
    ptr = head
    while ptr
      str << "( #{ptr.value} ) -> "
      ptr = ptr.next_node
    end
    str << 'nil'
  end
end

ll = LinkedList.new
puts ll
p ll.head

ll.append(5)
ll.append(7)
ll.append(7)
ll.append(nil)
ll.append(8)
puts ll
p ll.at(0).value
p ll.at(3).value
p ll.at(4).value
p ll.tail.value

puts ll.contains? 9
puts ll.contains? 7
puts ll.find(7)

puts ll.size

ll.prepend('first')
puts ll

ll.remove_at(3)
puts ll

ll.insert_at('seven', 3)
puts ll
