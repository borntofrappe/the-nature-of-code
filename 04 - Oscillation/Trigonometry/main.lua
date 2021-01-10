require "Mover"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
WIDTH_MIN = 30
WIDTH_MAX = 70
HEIGHT_MIN = 8
HEIGHT_MAX = 14
ANGLE_MIN = 0
ANGLE_MAX = 360
MOVERS = 10

function love.load()
  love.window.setTitle("Oscillation - Trigonometry")
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
  local x, y = love.mouse:getPosition()

  if x > 0 and x < WINDOW_WIDTH and y > 0 and y < WINDOW_HEIGHT then
    for i, mover in ipairs(movers) do
      local opposite = y - mover.y
      local adjacent = x - mover.x
      local angle = math.atan2(opposite, adjacent)
      mover.angle = angle
    end
  end
end

function love.draw()
  for i, mover in ipairs(movers) do
    mover:render()
  end
end
