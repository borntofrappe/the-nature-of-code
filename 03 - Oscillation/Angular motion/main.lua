require "Mover"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
WIDTH_MIN = 10
WIDTH_MAX = 50
HEIGHT_MIN = 10
HEIGHT_MAX = 50
ANGLE_MIN = 0
ANGLE_MAX = 360
MOVERS = 10
ANGULAR_ACCELERATION = 0.001
ANGULAR_VELOCITY_THRESHOLD = 0.1

function love.load()
  love.window.setTitle("Oscillation - Angular motion")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  movers = {}
  for i = 1, MOVERS do
    table.insert(movers, Mover:new())
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    movers = {}
    for i = 1, MOVERS do
      table.insert(movers, Mover:new())
    end
  end
end

function love.update(dt)
  for i, mover in ipairs(movers) do
    mover:update(dt)
  end

  local x, y = love.mouse:getPosition()

  if x > 0 and x < WINDOW_WIDTH and y > 0 and y < WINDOW_HEIGHT then
    for i, mover in ipairs(movers) do
      if x < mover.x then
        mover.angularAcceleration = ANGULAR_ACCELERATION * -1
      else
        mover.angularAcceleration = ANGULAR_ACCELERATION
      end
    end
  end
end

function love.draw()
  for i, mover in ipairs(movers) do
    mover:render()
  end
end
