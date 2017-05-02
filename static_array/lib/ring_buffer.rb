require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    self.length = 0
    self.capacity = 8
    self.store = StaticArray.new(8)
    self.start_idx = 0
  end

  # O(1)
  def [](index)
    check_index(index)
    store[(start_idx + index) % capacity]
  end

  # O(1)
  def []=(index, val)
    check_index(index)
    store[(start_idx + index) % capacity] = val
  end

  # O(1)
  def pop
    raise "array is empty" if length == 0

    val = self[length - 1]
    self[length - 1] = nil
    self.length -= 1

    val
  end

  # O(1) ammortized
  def push(val)
    resize! if length == capacity
    self.length += 1
    self[length - 1] = val
  end

  # O(1)
  def shift
    raise "array is empty" if length == 0
    val = self[0]

    self[0] = nil
    self.start_idx = (start_idx + 1) % capacity
    self.length -= 1

    val
  end

  # O(1) ammortized
  def unshift(val)
    resize! if length == capacity

    self.length += 1
    self.start_idx = (start_idx - 1) % capacity

    self[0] = val
  end

  # protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
    raise "index out of bounds" unless index.between?(0, length - 1)
  end

  def resize!
    new_cap = capacity * 2
    new_store = StaticArray.new(new_cap)
    length.times { |i| new_store[i] = self[i] }
    self.capacity, self.store = new_cap, new_store
    self.start_idx = 0
  end
end
