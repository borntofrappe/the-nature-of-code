require "Mover"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
RADIUS = 5

function love.load()
  love.window.setTitle("Randomness - Probability")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  mover = Mover:new()

  history = {
    {
      ["x"] = mover.x,
      ["y"] = mover.y
    }
  }
end

function love.update(dt)
  mover:randomWalk()
  table.insert(
    history,
    {
      ["x"] = mover.x,
      ["y"] = mover.y
    }
  )
end

function love.draw()
  mover:render()

  for i, point in ipairs(history) do
    love.graphics.setColor(0.11, 0.11, 0.11, 0.1)
    love.graphics.circle("fill", point.x, point.y, 1)
  end
end
