require "Point"
require "Guess"
require "Perceptron"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500

LEARNING_RATE = 0.1
M = 0.3
Q = 0.2

POINTS = 100
POINT_LINE_WIDTH = 2
POINT_RADIUS = 5

GUESS_RADIUS = POINT_RADIUS + POINT_LINE_WIDTH
GUESS_LINE_WIDTH = POINT_LINE_WIDTH

LINE_WIDTH = 2

function love.load()
  love.window.setTitle("Neural networks - Perceptron line")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  points = {}
  indexPoints = 1
  guesses = {}

  for i = 1, POINTS do
    table.insert(points, Point:new())
  end

  line = {
    map(-1, -1, 1, 0, WINDOW_WIDTH),
    map(f(-1), -1, 1, WINDOW_HEIGHT, 0),
    map(1, -1, 1, 0, WINDOW_WIDTH),
    map(f(1), -1, 1, WINDOW_HEIGHT, 0)
  }

  perceptron = Perceptron:new(#points[1].inputs)

  perceptronLine = {
    map(-1, -1, 1, 0, WINDOW_WIDTH),
    map(perceptron:f(-1), -1, 1, WINDOW_HEIGHT, 0),
    map(1, -1, 1, 0, WINDOW_WIDTH),
    map(perceptron:f(1), -1, 1, WINDOW_HEIGHT, 0)
  }

  for i, point in ipairs(points) do
    local output = perceptron:guess(point.inputs)
    table.insert(guesses, Guess:new(point.x, point.y, output == point.label))
  end
end

function love.update(dt)
  if love.mouse.isDown(1) then
    if indexPoints > #points then
      indexPoints = 1
    end

    local point = points[indexPoints]
    perceptron:train(point.inputs, point.label)
    indexPoints = indexPoints + 1

    perceptronLine = {
      map(-1, -1, 1, 0, WINDOW_WIDTH),
      map(perceptron:f(-1), -1, 1, WINDOW_HEIGHT, 0),
      map(1, -1, 1, 0, WINDOW_WIDTH),
      map(perceptron:f(1), -1, 1, WINDOW_HEIGHT, 0)
    }

    guesses = {}
    for i, point in ipairs(points) do
      local output = perceptron:guess(point.inputs)
      table.insert(guesses, Guess:new(point.x, point.y, output == point.label))
    end
  end
end

function love.draw()
  love.graphics.setLineWidth(LINE_WIDTH)
  love.graphics.setColor(0.21, 0.21, 0.21, 1)
  love.graphics.line(line)
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.line(perceptronLine)

  for i, point in ipairs(points) do
    point:render()
  end

  for i, guess in ipairs(guesses) do
    guess:render()
  end
end

function f(x)
  return M * x + Q
end

function map(value, currentMin, currentMax, newMin, newMax)
  return (value - currentMin) / (currentMax - currentMin) * (newMax - newMin) + newMin
end
