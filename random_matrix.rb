class RandomMatrix
  attr_accessor :size, :matrix
  def initialize(size)
    self.size = size
    self.matrix = (1..size).map do
      Array.new(size, 0)
    end
  end

  def each(&block)
    matrix.each do |row|
      column.each(&:block)
    end
  end

  def each_with_indexes(&block)
    matrix.each_with_index do |row, row_index|
      row.each_with_index do |value, column_index|
        yield(value, row_index, column_index)
      end
    end
  end

  def randomize(max = 1)
    size.times do |x|
      size.times do |y|
        value = if block_given?
          yield(x, y)
        else
          rand(max + 1)
        end
        matrix[x][y] = value
      end
    end
  end

  def [](x, y)
    matrix[x][y]
  end

  def []=(x, y, value)
    matrix[x][y] = value
  end

  def around(row_position, col_position)
    directions = []
    max_row_position = size-1
    max_col_position = size-1

    ([row_position-1, 0].max..[row_position+1, max_row_position].min).each do |sibling_row_position|
      ([col_position-1, 0].max..[col_position+1, max_col_position].min).each do |sibling_col_position|
        yield matrix[sibling_row_position][sibling_col_position]
      end
    end
  end

  def to_s
    output = []

    size.times do |x|
      output << []
      size.times do |y|
        if block_given?
          output.last << yield(matrix[x][y])
        else
         output.last << matrix[x][y]
        end
      end
    end

    output.map { |w| w.join(' ') }.join("\n")
  end
end

#list = []; 10.times { |x| 10.times { |y| column = (list[x] ||= []); column[y] = rand(2) } }; list.each { |l| l.each { |i| if i == 1;print ' x';else; print '  ';end;}; puts };1
#
#def around(list, row_position, col_position)
#  total = 0
#
#  directions = []
#  max_row_position = list.size
#  max_column_postition = list.size
#
#  ([row_position-1, 0].max..[row_position+1, max_row_position].min).each do |sibling_row_position|
#    ([[col_position-1, 0].max..[col_position+1, max_col_position].min).each do |sibling_col_position|
#      total += list[siblign_row_position][sibling_col_position]
#    end
#  end
#end

size = 40

matrix = RandomMatrix.new(size)
matrix.randomize do |y,x|
  if 2*rand*x - y < 0
    1
  else
    0
  end
end

puts matrix.to_s
inspected = matrix.to_s do |x|
  if x == 1
    'X'
  else
    ' '
  end
end

puts inspected
puts
around_matrix = RandomMatrix.new(size)
matrix.each_with_indexes do |value, row_index, col_index|
  total = 0
  matrix.around(row_index, col_index) do |around_value|
    total += around_value
  end
  around_matrix[row_index,col_index] = total
end

diff_matrix = RandomMatrix.new(size)
matrix.each_with_indexes do |value, row_index, col_index|
  total = 0
  matrix.around(row_index, col_index) do |around_value|
    total += 1 if around_value != value
  end
  diff_matrix[row_index,col_index] = total
end

puts around_matrix
puts
puts diff_matrix
