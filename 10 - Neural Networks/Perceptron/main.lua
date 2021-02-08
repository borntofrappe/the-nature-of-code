require "Point"
require "Guess"
require "Perceptron"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500

WEIGHTS = 2
LEARNING_RATE = 0.1

POINTS = 100
POINT_LINE_WIDTH = 2
POINT_RADIUS = 5

GUESS_RADIUS = POINT_RADIUS + POINT_LINE_WIDTH
GUESS_LINE_WIDTH = POINT_LINE_WIDTH

LINE_WIDTH = 2

function love.load()
  love.window.setTitle("Neural networks - Perceptron")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  points = {}
  indexPoints = 1
  guesses = {}

  for i = 1, POINTS do
    table.insert(points, Point:new())
  end

  perceptron = Perceptron:new()

  for i, point in ipairs(points) do
    local x = point.x
    local y = point.y
    local output = perceptron:guess({x, y})
    table.insert(guesses, Guess:new(x, y, output == point.label))
  end
end

function love.update(dt)
  if love.mouse.isDown(1) then
    if indexPoints > #points then
      perceptron = Perceptron:new()
      indexPoints = 1
    else
      local point = points[indexPoints]
      local x = point.x
      local y = point.y
      perceptron:train({x, y}, point.label)
      indexPoints = indexPoints + 1
    end

    guesses = {}
    for i, point in ipairs(points) do
      local x = point.x
      local y = point.y
      local output = perceptron:guess({x, y})
      table.insert(guesses, Guess:new(x, y, output == point.label))
    end
  end
end

function love.draw()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.print("Points: " .. #points, 8, 8)
  love.graphics.print("Points trained: " .. indexPoints - 1, 8, 24)

  love.graphics.setLineWidth(LINE_WIDTH)
  love.graphics.line(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

  for i, point in ipairs(points) do
    point:render()
  end

  for i, guess in ipairs(guesses) do
    guess:render()
  end
end
