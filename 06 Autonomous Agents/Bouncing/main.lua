LVector = require "LVector"
require "Vehicle"
require "Boundary"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
RADIUS = 7
LINE_WIDTH_BOUNDARY = 1
MAX_SPEED = 15
MAX_FORCE = 1
UPDATE_SPEED = 20
PADDING = 20
BOUNCE_FORCE = 5

function love.load()
  love.window.setTitle("Autonomous Agents - Bouncing")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  boundary = Boundary:new()
  vehicle = Vehicle:new()
end

function love.update(dt)
  vehicle:update(dt)
  vehicle:moveWithin(boundary)
end

function love.draw()
  boundary:render()
  vehicle:render()
end
