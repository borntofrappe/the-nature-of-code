LVector = require "LVector"
require "Oscillator"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
RADIUS = 14
UPDATE_SPEED = 50
ANGULAR_VELOCITY_MIN = 1
ANGULAR_VELOCITY_MAX = 4
OSCILLATORS = 10
AMPLITUDE_MIN = math.floor(math.min(WINDOW_WIDTH, WINDOW_HEIGHT) / 5)
AMPLITUDE_MAX = math.floor(math.min(WINDOW_WIDTH, WINDOW_HEIGHT) / 2.5)

function love.load()
  love.window.setTitle("Oscillation - Oscillation with angular velocity")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  oscillators = {}
  for i = 1, OSCILLATORS do
    local oscillator = Oscillator:new()
    table.insert(oscillators, oscillator)
  end
end

function love.update(dt)
  for i, oscillator in ipairs(oscillators) do
    oscillator:update(dt)
  end
end

function love.draw()
  love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)

  for i, oscillator in ipairs(oscillators) do
    oscillator:render()
  end
end
