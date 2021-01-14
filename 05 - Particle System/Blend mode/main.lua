WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
VELOCITY_X_MAX = 60
VELOCITY_Y_MIN = 50
VELOCITY_Y_MAX = 100
GRAVITY = -40
WIND = 200
UPDATE_SPEED = 0.5

LVector = require "LVector"
require "ParticleSystem"

function love.load()
  love.window.setTitle("Particle Systems - Blend mode")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

  math.randomseed(os.time())
  particleSystem = ParticleSystem:new()
  img = love.graphics.newImage("particle.png")
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
