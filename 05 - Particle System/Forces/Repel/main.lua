WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
VELOCITY_X_MAX = 60
VELOCITY_Y_MIN = 50
VELOCITY_Y_MAX = 150
GRAVITY = 300
WIND = 500
RADIUS_PARTICLE = 5
SIZE_PARTICLE = 10
RADIUS_REPELLER = 15
PADDING_REPELLER = 20
UPDATE_SPEED = 0.25
REPULSION_FORCE = 100
DISTANCE_MIN = 2
DISTANCE_MAX = 20

LVector = require "LVector"
require "ParticleSystem"
require "Repeller"

function love.load()
  love.window.setTitle("Particle Systems - Repel")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())
  particleSystem = ParticleSystem:new()
  repeller = Repeller:new(WINDOW_WIDTH / 2 + 50, WINDOW_HEIGHT / 2)
end

function love.update(dt)
  particleSystem:update(dt)
  local gravity = LVector:new(0, GRAVITY)
  particleSystem:applyForce(gravity)
  particleSystem:applyRepeller(repeller)

  local x, y = love.mouse:getPosition()
  if x > 0 and x < WINDOW_WIDTH and y > 0 and y < WINDOW_HEIGHT then
    repeller.position.x = x
    repeller.position.y = y
  end
end

function love.draw()
  -- love.graphics.print("There are " .. #particleSystem.particles .. " particles", 8, 8)
  particleSystem:render()
  repeller:render()
end
