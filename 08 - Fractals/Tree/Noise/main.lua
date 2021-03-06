LVector = require "LVector"
require "Tree"

WINDOW_WIDTH = 640
WINDOW_HEIGHT = 460
UPDATE_SPEED = 30
ANGLE_MIN = math.pi / 8
ANGLE_MAX = math.pi / 4
LENGTH_INITIAL = 80
LENGTH_MULTIPLIER_MIN = 0.65
LENGTH_MULTIPLIER_MAX = 0.85
BRANCHES_MIN = 2
BRANCHES_MAX = 4
LENGTH_MIN = 5
LINEWIDTH_MAX = 7
LINEWIDTH_MIN = 1.15
NOISE_INITIAL_MAX = 1000
NOISE_INCREMENT = 0.01

function love.load()
  love.window.setTitle("Fractals - Tree - Noise")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  tree = Tree:new()
end

function love.mousepressed(x, y, button)
  if button == 1 then
    tree = Tree:new()
  end
end

function love.update(dt)
  tree:update(dt)
end

function love.draw()
  tree:render()
end
