require "Mover"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500

e = 2.71828
LINE_WIDTH = 2
POINTS = 200
OFFSET_INITIAL_MAX = 1000
OFFSET_INCREMENT = 0.02
RADIUS = 5

function love.load()
  love.window.setTitle("Randomness - Noise")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  noiseNumbers = getNoiseNumbers()

  mover = Mover:new()

  index = 1

  points = {}
  for i = 1, #noiseNumbers do
    local x = (i - 1) * WINDOW_WIDTH / #noiseNumbers
    local y = map(noiseNumbers[i], 0, 1, WINDOW_HEIGHT * 3 / 4, WINDOW_HEIGHT / 4)
    table.insert(points, x)
    table.insert(points, y)
  end
end

function love.update(dt)
  mover.x = points[index]
  mover.y = points[index + 1]
  index = index + 1 >= #points and 1 or index + 2
end

function love.draw()
  love.graphics.setColor(0.11, 0.11, 0.11, 0.2)
  love.graphics.setLineWidth(LINE_WIDTH)
  love.graphics.line(points)

  mover:render()
end

function map(value, currentMin, currentMax, newMin, newMax)
  return (value - currentMin) / (currentMax - currentMin) * (newMax - newMin) + newMin
end

function getNoiseNumbers()
  local offset = math.random(OFFSET_INITIAL_MAX)
  local noiseNumbers = {}

  for i = offset, offset + POINTS * OFFSET_INCREMENT, OFFSET_INCREMENT do
    local y = love.math.noise(i)
    if not min or y < min then
      min = y
    end
    if not max or y > max then
      max = y
    end
    table.insert(noiseNumbers, y)
  end

  return noiseNumbers
end
