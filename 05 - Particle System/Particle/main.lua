LVector = require "LVector"
require "Particle"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
VELOCITY_MIN = 20
VELOCITY_MAX = 80
GRAVITY = 300
RADIUS = 6
UPDATE_SPEED = 0.25

function love.load()
  love.window.setTitle("Particle Systems - Particle")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())
  particle = Particle:new()
end

function love.update(dt)
  particle:update(dt)
end

function love.draw()
  particle:render()
end
