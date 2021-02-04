Perceptron = {}
Perceptron.__index = Perceptron

function Perceptron:new()
  local weights = {}
  for i = 1, WEIGHTS do
    table.insert(weights, math.random())
  end

  local this = {
    ["weights"] = weights
  }

  setmetatable(this, self)
  return this
end

function Perceptron:activate(n)
  return n >= 0 and 1 or -1
end

function Perceptron:guess(inputs)
  local weightedSum = 0
  for i = 1, #self.weights do
    weightedSum = weightedSum + inputs[i] * self.weights[i]
  end

  local output = self:activate(weightedSum)
  return output
end

function Perceptron:train(inputs, target)
  local guess = self:guess(inputs)
  local error = target - guess

  for i = 1, #self.weights do
    self.weights[i] = self.weights[i] + error * inputs[i] * LEARNING_RATE
  end
end
