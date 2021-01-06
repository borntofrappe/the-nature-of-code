require "Mover"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500

e = 2.71828
LINE_WIDTH = 2
WINDOW_MAX_HEIGHT = WINDOW_HEIGHT - LINE_WIDTH
MEAN = 0
STANDARD_DEVIATION = 1
MAX_HEIGHT = 1 / ((2 * math.pi) ^ 0.5 * STANDARD_DEVIATION)
POINTS = 200
RADIUS = 5
UPPER_BOUNDARY = WINDOW_HEIGHT / 4
LOWER_BOUNDARY = WINDOW_HEIGHT * 3 / 4

function love.load()
  love.window.setTitle("Randomness - Normal distribution")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  normalNumbers = getNormalNumbers()

  mover = Mover:new()

  points = {}
  for i = 1, #normalNumbers do
    local x = (i - 1) * WINDOW_WIDTH / (#normalNumbers - 1)
    local y = map(normalNumbers[i], 0, MAX_HEIGHT, LOWER_BOUNDARY, UPPER_BOUNDARY)
    table.insert(points, x)
    table.insert(points, y)
  end

  -- update index to consider the coordinates in the points table
  index = 1
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

function getNormalDistribution(x, mu, sigma)
  return 1 / (sigma * (2 * math.pi) ^ 0.5) * e ^ ((-1 / 2) * ((x - mu) / sigma) ^ 2)
end

function map(value, currentMin, currentMax, newMin, newMax)
  return (value - currentMin) / (currentMax - currentMin) * (newMax - newMin) + newMin
end

function getNormalNumbers()
  local normalNumbers = {}

  for x = -3 * STANDARD_DEVIATION, 3 * STANDARD_DEVIATION, STANDARD_DEVIATION * 6 / POINTS do
    local y = getNormalDistribution(x, MEAN, STANDARD_DEVIATION)
    table.insert(normalNumbers, y)
  end

  return normalNumbers
end
