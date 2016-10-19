require 'ruby-fann'

def calculate_output(input, series = 3)
  left = input.first(3).uniq == [1]
  right = input.last(3).uniq == [1]

  result = []

  if left
    result << 1
  else
    result << 0
  end

  if right
    result << 1
  else
    result << 0
  end

  return result
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
    train_outputs << result
  end
end

train_inputs.uniq.each_with_index do |input, index|
  puts "#{input.inspect} => #{train_outputs[index].inspect}"
end

puts train_inputs.uniq.size

puts train_outputs.map(&:inspect)

# exit


1.upto(64) do |neurons|
  puts "NEURONS: #{neurons}"
  train = RubyFann::TrainData.new(inputs: train_inputs, desired_outputs: train_outputs)

  fann = RubyFann::Standard.new(num_inputs: 6, hidden_neurons: [neurons], num_outputs: 2)
  fann.train_on_data(train, 5000, 10, 0.00001) # 1000 max_epochs, 10 errors between reports and 0.1 desired MSE (mean-squared-error)
  puts fann.run([0, 1, 0, 1, 1, 1]).inspect
  puts fann.run([1, 1, 1, 0, 0, 0]).inspect
  puts fann.run([0, 0, 0, 1, 1, 1]).inspect
  puts fann.run([0, 1, 0, 1, 0, 1]).inspect
  puts fann.run([1, 0, 1, 0, 0, 0]).inspect
  puts fann.run([0, 0, 0, 1, 0, 1]).inspect
  gets
end
