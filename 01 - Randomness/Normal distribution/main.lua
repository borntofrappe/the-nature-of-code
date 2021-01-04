WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500

e = 2.71828

POINTS = 100
LINE_WIDTH = 2
WINDOW_MAX_HEIGHT = WINDOW_HEIGHT - LINE_WIDTH

function love.load()
  love.window.setTitle("Randomness - Normal distribution")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  mean = WINDOW_WIDTH / 2
  standardDeviation = WINDOW_WIDTH / 8
  maxHeight = 1 / ((2 * math.pi) ^ 0.5 * standardDeviation)

  points = getPoints(mean, standardDeviation, maxHeight)
end

function love.mousepressed(x, y, button)
  mean = x
  standardDeviation = map(y, 0, WINDOW_HEIGHT, WINDOW_WIDTH / 8, WINDOW_WIDTH / 2)
  points = getPoints(mean, standardDeviation, maxHeight)
end

function love.draw()
  love.graphics.setColor(0.12, 0.12, 0.13, 1)
  love.graphics.setLineWidth(LINE_WIDTH)
  love.graphics.line(points)
end

function getNormalDistribution(x, mu, sigma)
  return 1 / (sigma * (2 * math.pi) ^ 0.5) * e ^ ((-1 / 2) * ((x - mu) / sigma) ^ 2)
end

function map(value, currentMin, currentMax, newMin, newMax)
  return (value - currentMin) / (currentMax - currentMin) * (newMax - newMin) + newMin
end

function getPoints(mean, standardDeviation, maxHeight)
  local points = {}
  for i = 1, POINTS + 1 do
    local x = (i - 1) * WINDOW_WIDTH / POINTS
    local y = WINDOW_HEIGHT - map(getNormalDistribution(x, mean, standardDeviation), 0, maxHeight, 0, WINDOW_MAX_HEIGHT)
    table.insert(points, x)
    table.insert(points, y)
  end
  return points
end
