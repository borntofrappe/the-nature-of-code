LVector = require "LVector"
require "Pellet"
require "DNA"
require "Bloop"
require "Population"

WINDOW_WIDTH = 600
WINDOW_HEIGHT = 450

BLOOP_RADIUS_MIN = 3
BLOOP_RADIUS_MAX = 21
BLOOP_RADIUS_VARIATION_PERCENTAGE = 0.1
BLOOP_LIFESPAN = 1
BLOOP_LIFESPAN_INCREMENT = 0.5
BLOOP_LIFESPAN_UPDATE_SPEED = 0.15
BLOOP_INITIAL_POPULATION = 20
BLOOP_MOVEMENT_UPDATE_SPEED_MAX = 50
BLOOP_MOVEMENT_UPDATE_SPEED_MIN = 0.02
BLOOP_OFFSET_INITIAL_MAX = 1000
BLOOP_OFFSET_DISTANCE = 1000
BLOOP_OFFSET_INCREMENT_MIN = 0.02
BLOOP_OFFSET_INCREMENT_MAX = 0.1
BLOOP_ODDS = 800

PELLET_SIZE = 8
PELLET_POPULATION = 15
PELLET_LINE_WIDTH = 1

function love.load()
  love.window.setTitle("The evolution of code - Ecosystem simulation")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  population = Population:new()
end

function love.update(dt)
  population:update(dt)
end

function love.draw()
  population:render()
end

function map(value, currentMin, currentMax, newMin, newMax)
  return (value - currentMin) / (currentMax - currentMin) * (newMax - newMin) + newMin
end
