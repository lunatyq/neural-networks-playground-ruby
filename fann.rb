require 'ruby-fann'

def calculate_output(input)
  left = input.first(3).uniq == [1]
  right = input.last(3).uniq == [1]

  return if left && right

  if left || right
    1
  else
    0
  end
end

train_inputs = []
train_outputs = []

1000.times do |input|
  input = (1..6).map do
    rand(2)
  end

  next if train_inputs.include?(input)

  result = calculate_output(input)

  if result
    train_inputs << input
    train_outputs << [result]
  end
end

train_inputs.uniq.each_with_index do |input, index|
  puts "#{input.inspect} => #{train_outputs[index].inspect}"
end

puts train_inputs.uniq.size

# exit


1.upto(24) do |neurons|
  puts "NEURONS: #{neurons}"
  train = RubyFann::TrainData.new(inputs: train_inputs, desired_outputs: train_outputs)

  fann = RubyFann::Standard.new(num_inputs: 6, hidden_neurons: [neurons], num_outputs: 1)
  fann.train_on_data(train, 5000, 10, 0.01) # 1000 max_epochs, 10 errors between reports and 0.1 desired MSE (mean-squared-error)
  puts fann.run([0, 1, 0, 1, 1, 1])
  puts fann.run([1, 1, 1, 0, 0, 0])
  puts fann.run([0, 0, 0, 1, 1, 1])
  puts fann.run([0, 1, 0, 1, 0, 1])
  puts fann.run([1, 0, 1, 0, 0, 0])
  puts fann.run([0, 0, 0, 1, 0, 1])
  gets
end
