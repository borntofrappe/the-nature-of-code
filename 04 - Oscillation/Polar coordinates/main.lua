require "Mover"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
SIZE = 16
UPDATE_SPEED_DISTANCE = 10
UPDATE_SPEED_ANGLE = 3
HISTORY_MAX = 4200

function love.load()
  love.window.setTitle("Oscillation - Polar coordinates")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  mover = Mover:new()
  history = {mover.x, mover.y}
end

function love.update(dt)
  mover:update(dt)
  table.insert(history, mover.x)
  table.insert(history, mover.y)
  if #history > HISTORY_MAX then
    table.remove(history, 1)
    table.remove(history, 1)
  end
end

function love.draw()
  love.graphics.translate(WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  mover:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 0.5)
  love.graphics.setLineWidth(1)
  love.graphics.line(history)
end
