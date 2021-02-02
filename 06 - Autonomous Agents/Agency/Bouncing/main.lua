LVector = require "LVector"
require "Vehicle"
require "Boundary"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
SIZE_VEHICLE = 8
MAX_SPEED = 15
MAX_FORCE = 1
VELOCITY_MIN = 5
VELOCITY_MAX = 20
PADDING_BOUNDARY = 20
LINE_WIDTH_BOUNDARY = 1
BOUNCE_FORCE = 5
UPDATE_SPEED = 20

function love.load()
  love.window.setTitle("Autonomous Agents - Agency - Bouncing")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  boundary = Boundary:new()
  vehicle = Vehicle:new()
end

function love.mousepressed(x, y, button)
  if button == 1 then
    boundary.isVisible = not boundary.isVisible
  end
end

function love.update(dt)
  vehicle:update(dt)
  vehicle:moveWithin(boundary)
end

function love.draw()
  boundary:render()
  vehicle:render()
end
