LVector = require "LVector"
require "Target"
require "Field"
require "Vehicle"
require "Population"

WINDOW_WIDTH = 705
WINDOW_HEIGHT = 480

SIZE_VEHICLE = 5
MAX_SPEED_VEHICLE = 10
MAX_FORCE_VEHICLE = 1
X_VEHICLE = WINDOW_WIDTH / 4
Y_VEHICLE = WINDOW_HEIGHT / 2

RESOLUTION_FLOW_FIELD = 15
LINE_WIDTH_FLOW_FIELD = 0.2

RADIUS_TARGET = 7
X_TARGET = WINDOW_WIDTH * 3 / 4
Y_TARGET = WINDOW_HEIGHT / 2

UPDATE_SPEED = 30

SIZE_POPULATION = 20
MUTATION_ODDS = 100
LIFESPAN = 50
MAX_DISTANCE_VEHICLE = 500
MAX_FITNESS = 1

function love.load()
  love.window.setTitle("The evolution of code - Evolutionary flow field")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  local position = LVector:new(X_TARGET, Y_TARGET)
  local bestField = nil
  target = Target:new(position)
  population = Population:new(SIZE_POPULATION, target, MUTATION_ODDS)
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
  population:render()
  target:render()
end

function map(value, currentMin, currentMax, newMin, newMax)
  return (value - currentMin) / (currentMax - currentMin) * (newMax - newMin) + newMin
end
