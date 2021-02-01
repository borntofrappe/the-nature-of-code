LVector = require "LVector"
require "Target"
require "Field"
require "Vehicle"
require "Population"

WINDOW_WIDTH = 640
WINDOW_HEIGHT = 500

SIZE_VEHICLE = 8
MAX_SPEED_VEHICLE = 10
MAX_FORCE_VEHICLE = 1
X_VEHICLE = WINDOW_WIDTH / 4
Y_VEHICLE = WINDOW_HEIGHT / 2

RESOLUTION_FLOW_FIELD = 20
LINE_WIDTH_FLOW_FIELD = 0.5

RADIUS_TARGET = 10
X_TARGET = WINDOW_WIDTH * 3 / 4
Y_TARGET = WINDOW_HEIGHT / 2

UPDATE_SPEED = 15

SIZE = 5
MUTATION_ODDS = 100
LIFESPAN = 100

function love.load()
  love.window.setTitle("The evolution of code - Not so random flow field")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  local position = LVector:new(X_TARGET, Y_TARGET)
  target = Target:new(position)
  population = Population:new(SIZE, target, MUTATION_ODDS)
end

function love.mousepressed(x, y, button)
  if button == 1 then
    local position = LVector:new(x, y)
    target.position = position
  end
end

function love.update(dt)
  population:update(dt)
end

function love.draw()
  target:render()
  population:render()
end
