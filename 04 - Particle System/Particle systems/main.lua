LVector = require "LVector"
require "ParticleSystem"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
VELOCITY_X_MAX = 60
VELOCITY_Y_MIN = 50
VELOCITY_Y_MAX = 150
GRAVITY = 300
RADIUS = 5
UPDATE_SPEED = 1

function love.load()
  love.window.setTitle("Particle Systems - Particle systems")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  particleSystems = {ParticleSystem:new(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)}
end

function love.update(dt)
  for i = #particleSystems, 1, -1 do
    particleSystems[i]:update(dt)
    if #particleSystems[i].particles == 0 then
      table.remove(particleSystems, i)
    end
  end

  local x, y = love.mouse:getPosition()
  if x > 0 and x < WINDOW_WIDTH and y > 0 and y < WINDOW_HEIGHT then
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    table.insert(particleSystems, ParticleSystem:new(x, y))
  end
end

function love.draw()
  -- love.graphics.print("There are " .. #particleSystems .. " particle systems", 8, 8)
  for i, particleSystem in ipairs(particleSystems) do
    particleSystem:render()
  end
end
