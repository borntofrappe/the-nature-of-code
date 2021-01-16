require "Mover"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500

e = 2.71828
LINE_WIDTH = 2
OFFSET_INITIAL_MAX = 1000
OFFSET_INCREMENT = 0.02
POINTS = 200
RADIUS = 5
UPPER_BOUNDARY = WINDOW_HEIGHT / 4
LOWER_BOUNDARY = WINDOW_HEIGHT * 3 / 4
OPACITY_MAX = 0.25
NOISE_BACKGROUND_SIZE = 5

function love.load()
  love.window.setTitle("Randomness - Noise")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  noiseNumbers = getNoiseNumbers()

  mover = Mover:new()

  points = {}
  for i = 1, #noiseNumbers do
    local x = (i - 1) * WINDOW_WIDTH / (#noiseNumbers - 1)
    local y = map(noiseNumbers[i], 0, 1, LOWER_BOUNDARY, UPPER_BOUNDARY)
    table.insert(points, x)
    table.insert(points, y)
  end

  -- update index to consider the coordinates in the points table
  index = 1

  noiseBackground = getNoiseBackground()
end

function love.update(dt)
  mover.x = points[index]
  mover.y = points[index + 1]
  index = index + 1 >= #points and 1 or index + 2
end

function love.draw()
  for x = 1, #noiseBackground do
    for y = 1, #noiseBackground[x] do
      love.graphics.setColor(0.11, 0.11, 0.11, noiseBackground[x][y])
      love.graphics.rectangle(
        "fill",
        (x - 1) * NOISE_BACKGROUND_SIZE,
        (y - 1) * NOISE_BACKGROUND_SIZE,
        NOISE_BACKGROUND_SIZE,
        NOISE_BACKGROUND_SIZE
      )
    end
  end

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

function getNoiseBackground()
  local offsetInitialX = math.random(OFFSET_INITIAL_MAX)
  local offsetInitialY = math.random(OFFSET_INITIAL_MAX)
  local offsetX = offsetInitialX
  local offsetY = offsetInitialY

  local noiseBackground = {}
  for x = 1, math.floor(WINDOW_WIDTH / NOISE_BACKGROUND_SIZE) do
    -- set offsetY back to the first value for every column
    -- this to have the cell connected to the one in the previous row
    offsetY = offsetInitialY
    noiseBackground[x] = {}
    table.insert(noiseBackground, {})
    for y = 1, math.floor(WINDOW_HEIGHT / NOISE_BACKGROUND_SIZE) do
      -- half the random numeber to produce numbers in the (0; OPACITY_MAX) range
      -- the risk is an overly dark background
      noiseBackground[x][y] = love.math.noise(offsetX, offsetY) * OPACITY_MAX
      offsetY = offsetY + OFFSET_INCREMENT
    end
    offsetX = offsetX + OFFSET_INCREMENT
  end

  return noiseBackground
end
