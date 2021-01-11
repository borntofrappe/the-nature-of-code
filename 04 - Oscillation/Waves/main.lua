WINDOW_WIDTH = 600
WINDOW_HEIGHT = 400
CYCLES = 1
AMPLITUDE = math.floor(WINDOW_HEIGHT / 6)
POINTS = 30 * CYCLES
RADIUS = 10 / CYCLES
LINE_WIDTH = 1 / CYCLES
ANGULAR_VELOCITY = math.pi * 2 / POINTS * CYCLES
ANGLE_INCREMENT = 0.02

function love.load()
  love.window.setTitle("Oscillation - Waves")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  angle = 0
  points = getPoints(angle)
end

function love.update(dt)
  angle = (angle + ANGLE_INCREMENT) % (math.pi * 2)
  points = getPoints(angle)
end

function getPoints(theta)
  local angle = theta
  local points = {}
  for i = 1, POINTS do
    local x = (i - 1) * WINDOW_WIDTH / (POINTS - 1)
    angle = angle + ANGULAR_VELOCITY
    local y1 = AMPLITUDE * math.cos(angle)
    local y2 = AMPLITUDE * math.cos(angle) * -1
    table.insert(
      points,
      {
        ["x"] = x,
        ["y1"] = y1,
        ["y2"] = y2,
        ["r"] = RADIUS
      }
    )
  end
  return points
end

function love.draw()
  love.graphics.translate(0, WINDOW_HEIGHT / 2)

  love.graphics.setLineWidth(LINE_WIDTH)
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  for i, point in ipairs(points) do
    local radius = point.r
    love.graphics.line(point.x, point.y1, point.x, point.y2)
    love.graphics.circle("fill", point.x, point.y1, point.r)
    love.graphics.circle("fill", point.x, point.y2, point.r)
  end
end
