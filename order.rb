require 'ruby-fann'

corpus = %w(razaco niska cena uniewaznienie postepowania jest w tym przypadku nieodzowne).shuffle

def calculate_output(input)
  #left = input.first(3).uniq == [1]
  #right = input.last(3).uniq == [1]
  #
  #return if left && right
  #
  #if left || right
  #  1
  #else
  #  0
  #end

  if input == input.sort
    1
  else
    0
  end
end

train_inputs = []
train_outputs = []

results = Hash.new(0)

10000.times do
  input = (1..6).map { |w| rand(1000) }

  next if train_inputs.include?(input)

  result = calculate_output(input)

  total = results.values.reduce(:+) || 1.0

  if results[result] < total * 0.8
    train_inputs << input
    train_outputs << [result]
    results[result] += 1
  end

  input.shuffle
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
  fann.train_on_data(train, 5000, 10, 0.001) # 1000 max_epochs, 10 errors between reports and 0.1 desired MSE (mean-squared-error)
  puts fann.run([1, 2, 3, 4, 5, 6])
  puts fann.run([1, 2, 4, 3, 5, 6])
  puts fann.run([1, 2, 4, 3, 5, 6].reverse)
  gets
end
