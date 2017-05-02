require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    self.length = 0
    self.capacity = 8
    self.store = StaticArray.new(8)
  end

  # O(1)
  def [](index)
    check_index(index)
    store[index]
  end

  # O(1)
  def []=(index, value)
    check_index(index)
    store[index] = value
  end

  # O(1)
  def pop
    raise "array is empty" if length == 0
    val = self[length - 1]
    self[length - 1] = nil
    self.length -= 1
    val
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    resize! if length == capacity

    self.length += 1
    self[length - 1] = val
  end

  # O(n): has to shift over all the elements.
  def shift
    raise "array is empty" if length == 0

    val = self[0]
    (1...length).each { |i| self[i - 1] = self[i] }

    self.length -= 1
    val
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    resize! if length == capacity

    self.length += 1
    (length - 2).downto(0) { |i| self[ i + 1] = self[i] }

    self[0] = val
  end

  protected

  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
    raise "index out of bounds" unless index.between?(0, length - 1)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    new_cap = capacity * 2
    new_store = StaticArray.new(new_cap)
    length.times { |i| new_store[i] = store[i] }
    self.capacity, self.store = new_cap, new_store
  end
end
