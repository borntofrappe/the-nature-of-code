require "Pellet"
require "Blob"
require "Population"

WINDOW_WIDTH = 500
WINDOW_HEIGHT = 400

BLOB_RADIUS_MIN = 5
BLOB_RADIUS_MAX = 15
BLOB_LIFESPAN = 1
BLOB_LIFESPAN_INCREMENT = 0.5
BLOB_LIFESPAN_UPDATE_SPEED = 0.1
BLOB_INITIAL_POPULATION = 15
BLOB_MOVEMENT_UPDATE_SPEED_MAX = 1000
BLOB_MOVEMENT_UPDATE_SPEED_MIN = 100
BLOB_OFFSET_INITIAL_MAX = 1000
BLOB_OFFSET_DISTANCE = 1000
BLOB_OFFSET_INCREMENT_MIN = 0.02
BLOB_OFFSET_INCREMENT_MAX = 0.1
BLOB_ODDS = 800

PELLET_SIZE = 5
PELLET_POPULATION = 40
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
