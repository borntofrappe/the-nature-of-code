LVector = require "LVector"
require "Snowflake"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
PADDING = 20
LINE_WIDTH = 1
UPDATE_SPEED = 20
RADIUS = 180
SIDES_MIN = 3
SIDES_MAX = 10
SIDES = 3
GENERATIONS = 5

function love.load()
  love.window.setTitle("Fractals - Koch snowflake")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  snowflake = Snowflake:new()
end

function love.mousepressed(x, y, button)
  if button == 1 then
    snowflake = Snowflake:new(math.random(SIDES_MIN, SIDES_MAX))
  end
end

function love.draw()
  snowflake:render()
end
