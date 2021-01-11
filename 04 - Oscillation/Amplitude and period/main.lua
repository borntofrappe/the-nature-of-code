require "Oscillator"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
SIZE = 30
UPDATE_SPEED = 50
AMPLITUDE = WINDOW_WIDTH / 2.5
PERIOD = 150

function love.load()
  love.window.setTitle("Oscillation - Amplitude and period")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  oscillator = Oscillator:new()
end

function love.update(dt)
  oscillator:update(dt)
end

function love.draw()
  love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  oscillator:render()
end
