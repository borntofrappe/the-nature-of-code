LVector = require "LVector"
require "ParticleSystem"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
VELOCITY_MIN = 20
VELOCITY_MAX = 80
GRAVITY = 300
RADIUS = 6
UPDATE_SPEED = 0.25

function love.load()
  love.window.setTitle("Particle Systems - Particle system")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())
  particleSystem = ParticleSystem:new()
end

function love.update(dt)
  particleSystem:update(dt)

  local x, y = love.mouse:getPosition()
  if x > 0 and x < WINDOW_WIDTH and y > 0 and y < WINDOW_HEIGHT then
    particleSystem.origin = LVector:new(x, y)
  end
end

function love.draw()
  particleSystem:render()
end
