require "Mover"

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

  mover = Mover:new()
end

function love.update(dt)
  mover:update(dt)
end

function love.draw()
  love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  mover:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 0.5)
  love.graphics.setLineWidth(1)
  love.graphics.line(0, 0, mover.x, mover.y)
end
