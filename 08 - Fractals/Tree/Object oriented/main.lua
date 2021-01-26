LVector = require "LVector"
require "Tree"

WINDOW_WIDTH = 540
WINDOW_HEIGHT = 480
ANGLE = math.pi / 8
LENGTH_INITIAL = 100
LENGTH_MULTIPLIER = 0.75
LENGTH_MIN = 5
LINEWIDTH_MAX = 7
LINEWIDTH_MIN = 1
LINEWIDTH_CHANGE = 2

function love.load()
  love.window.setTitle("Fractals - Tree - Object oriented")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  tree = Tree:new()
end

function love.mousepressed(x, y, button)
  if button == 1 then
    tree:generate()
  end
  if button == 2 then
    tree = Tree:new()
  end
end

function love.draw()
  tree:render()
end
