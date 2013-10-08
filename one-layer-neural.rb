class Sample

  attr_accessor :weights

  def initialize(weights = [])
    @weights = weights
    @learns  = 0
  end

  def learning_value
    return 1.0 if @learns < 3
    1.0/Math.sqrt(@learns)
  end

  def train(input, result)
    last_guess = guess(input)

    diff  = last_guess - result

    # result, last_guess

    new_weights = []
    weights.each_with_index do |weight, index|
      new_weights << weight - diff * input[index]
    end

    self.weights = new_weights
  end

  def guess(input)
    raise "input has to match weights" unless weights.size == input.size
    total = 0

    weights.each_with_index do |weight, index|
      total += weight * input[index] * learning_value
    end

    #puts "#{@learns} #{learning_value}"
    @learns += 1
    total > 0 ? 1 : -1
  end
end

random = Sample.new([rand * (rand > 0.5 ? -1 : 1), rand * (rand > 0.5 ? -1 : 1)]) # Random weight at start
field  = Sample.new(random.weights)

unknown_function = lambda { |sample| sample.first * 10 + 100 > sample.last ? 1 : -1 }

require 'colored'
def print_result(sample, result)
  real_result = yield(sample)

  color = real_result == result ? 'green' : 'red'
  puts "#{sample.first}, #{sample.last} #{result} VS #{real_result} (REAL)".send(color)
end

puts "Before"

class RandomSample

  attr_reader :start, :stop, :size

  def initialize(start, stop, size)
    @start = start
    @stop  = stop
    @size  = size
  end

  def random
    rand * (stop - start) + start
  end

  def get
    (1..size).map { |d| random }
  end
end

rnd = RandomSample.new(0, 100, 2)

puts rnd.get.inspect

10.times do
  sample = rnd.get
  print_result(sample, random.guess(sample), &unknown_function)
end

10000.times do
  sample = rnd.get
  random.train(sample, unknown_function.call(sample))
end

#100.times do |x|
#  100.times do |y|
#    field.train([x,y], unknown_function.call([x,y]))
#  end
#end

puts "After"

10.times do
  sample = rnd.get
  print 'R: '; print_result(sample, random.guess(sample), &unknown_function)
  print 'F: '; print_result(sample, field.guess(sample), &unknown_function)
end

puts random.weights.inspect
puts field.weights.inspect
