LVector = require "LVector"
require "Particle"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
VELOCITY_X_MAX = 60
VELOCITY_Y_MIN = 50
VELOCITY_Y_MAX = 150
GRAVITY = 300
RADIUS = 5
UPDATE_SPEED = 0.25

function love.load()
  love.window.setTitle("Particle Systems - Particles")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())
  particles = {
    Particle:new()
  }
end

function love.update(dt)
  table.insert(particles, Particle:new())
  for i = #particles, 1, -1 do
    particles[i]:update(dt)
    if particles[i]:isDead() then
      table.remove(particles, i)
    end
  end
end

function love.draw()
  -- love.graphics.print("There are " .. #particles .. " particles", 8, 8)
  for i, particle in ipairs(particles) do
    particle:render()
  end
end
