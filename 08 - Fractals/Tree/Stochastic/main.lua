LVector = require "LVector"
require "Tree"

WINDOW_WIDTH = 640
WINDOW_HEIGHT = 460
UPDATE_SPEED = 20
ANGLE_MIN = math.pi / 8
ANGLE_MAX = math.pi / 4
LENGTH_INITIAL = 100
LENGTH_MULTIPLIER_MIN = 0.55
LENGTH_MULTIPLIER_MAX = 0.85
LENGTH_MIN = 5
LINEWIDTH_MAX = 8
LINEWIDTH_MIN = 1.25

function love.load()
  love.window.setTitle("Fractals - Tree - Stochastic")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  tree = Tree:new()
end

function love.mousepressed(x, y, button)
  if button == 1 then
    tree = Tree:new()
  end
end

function love.draw()
  tree:render()
end
