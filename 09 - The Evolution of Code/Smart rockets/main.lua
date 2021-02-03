LVector = require "LVector"
require "Target"
require "DNA"
require "Rocket"
require "Population"

WINDOW_WIDTH = 640
WINDOW_HEIGHT = 480
WINDOW_PADDING = 5

ROCKET_SIZE = 5
ROCKET_MAX_SPEED = 8
ROCKET_MAX_FORCE = 1
ROCKET_X = WINDOW_WIDTH / 2
ROCKET_Y = WINDOW_HEIGHT - WINDOW_PADDING

TARGET_RADIUS = 8
TARGET_X = WINDOW_WIDTH / 2
TARGET_Y = WINDOW_HEIGHT / 5

UPDATE_SPEED = 20
UPDATE_SPEED_ACCELERATION = 100

POPULATION_SIZE = 20
MUTATION_ODDS = 100
FRAMES = 400
ROCKET_MAX_DISTANCE = 500
FITNESS_MAX = 1
FITNESS_MIN = 0.1

function love.load()
  love.window.setTitle("The evolution of code - Smart rockets")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  target = Target:new(TARGET_X, TARGET_Y)
  population = Population:new(POPULATION_SIZE, MUTATION_ODDS, target)
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
