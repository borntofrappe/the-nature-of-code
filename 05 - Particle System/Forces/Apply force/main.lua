WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
VELOCITY_X_MAX = 60
VELOCITY_Y_MIN = 50
VELOCITY_Y_MAX = 150
MASS = 1
GRAVITY = 300
WIND = 500
RADIUS = 5
SIZE = 10
UPDATE_SPEED = 0.25
ANGULAR_ACCELERATION = 10

LVector = require "LVector"
require "ParticleSystem"

function love.load()
  love.window.setTitle("Particle Systems - Forces - Apply force")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())
  particleSystem = ParticleSystem:new()
end

function love.update(dt)
  particleSystem:update(dt)
  local gravity = LVector:new(0, GRAVITY)
  particleSystem:applyForce(gravity)

  local x, y = love.mouse:getPosition()
  if x > 0 and x < WINDOW_WIDTH and y > 0 and y < WINDOW_HEIGHT then
    particleSystem.origin.x = x
    particleSystem.origin.y = y
  end

  if love.mouse.isDown(1) then
    local wind = LVector:new(WIND, 0)
    particleSystem:applyForce(wind)
  end
  if love.mouse.isDown(2) then
    local wind = LVector:new(WIND * -1, 0)
    particleSystem:applyForce(wind)
  end
end

function love.draw()
  -- love.graphics.print("There are " .. #particleSystem.particles .. " particles", 8, 8)
  particleSystem:render()
end
