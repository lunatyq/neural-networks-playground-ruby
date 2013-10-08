
target_function = lambda { |x| Math.exp(x) }
gradient        = lambda { |x| Math.exp(x) }
step            = 0.1
epsilon         = 0.01
x = [2] # start with 10

current = x.first
while (current_gradient = gradient.call(current).abs) > epsilon
  current -= current_gradient*step
  x << current

  printf("%5.2f grad: %5.2f, value: %5.2f\n", current, current_gradient, target_function.call(current))
  #sleep 0.1
end

require 'pp'
pp x
