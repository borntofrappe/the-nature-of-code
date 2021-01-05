WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500

e = 2.71828
LINE_WIDTH = 2
WINDOW_MAX_HEIGHT = WINDOW_HEIGHT - LINE_WIDTH
MEAN = 0
STANDARD_DEVIATION = 1
MAX_HEIGHT = 1 / ((2 * math.pi) ^ 0.5 * STANDARD_DEVIATION)
POINTS = 100

function love.load()
  love.window.setTitle("Randomness - Normal distribution")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  points = getPoints()

  line = {}
  for i = 1, #points do
    local x = (i - 1) * WINDOW_WIDTH / #points
    local y = map(points[i], 0, MAX_HEIGHT, WINDOW_HEIGHT, WINDOW_HEIGHT - WINDOW_MAX_HEIGHT)
    table.insert(line, x)
    table.insert(line, y)
  end
end

-- function love.mousepressed(x, y, button)
--   mean = x
--   standardDeviation = map(y, 0, WINDOW_HEIGHT, WINDOW_WIDTH / 8, WINDOW_WIDTH / 2)
--   points = getPoints(mean, standardDeviation, maxHeight)
-- end

function love.draw()
  love.graphics.setColor(0.12, 0.12, 0.13, 1)
  love.graphics.setLineWidth(LINE_WIDTH)
  love.graphics.line(line)
end

function getNormalDistribution(x, mu, sigma)
  return 1 / (sigma * (2 * math.pi) ^ 0.5) * e ^ ((-1 / 2) * ((x - mu) / sigma) ^ 2)
end

function map(value, currentMin, currentMax, newMin, newMax)
  return (value - currentMin) / (currentMax - currentMin) * (newMax - newMin) + newMin
end

function getPoints()
  local points = {}

  for x = -3, 3, 0.05 do
    local y = getNormalDistribution(x, MEAN, STANDARD_DEVIATION)
    table.insert(points, y)
  end
  return points
end
