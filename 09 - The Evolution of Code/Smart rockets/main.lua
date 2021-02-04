LVector = require "LVector"
require "Target"
require "DNA"
require "Rocket"
require "Population"
require "Obstacle"

WINDOW_WIDTH = 640
WINDOW_HEIGHT = 480
WINDOW_PADDING = 10

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
FRAMES = 300
FITNESS_COLLISION_MULTIPLIER = 0.1

OBSTACLE_WIDTH = 200
OBSTACLE_HEIGHT = 20
OBSTACLE_X = WINDOW_WIDTH / 2
OBSTACLE_Y = WINDOW_HEIGHT / 2 - OBSTACLE_HEIGHT / 2

MOUSE_POINT_SIZE = 5
MOUSE_LINE_WIDTH = 1

function love.load()
  love.window.setTitle("The evolution of code - Smart rockets")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())

  obstacles = {Obstacle:new(OBSTACLE_X, OBSTACLE_Y, OBSTACLE_WIDTH, OBSTACLE_HEIGHT)}

  target = Target:new(TARGET_X, TARGET_Y)
  population = Population:new(POPULATION_SIZE, MUTATION_ODDS, target, obstacles)

  mouse = {
    ["x1"] = 0,
    ["y1"] = 0,
    ["x2"] = 0,
    ["y2"] = 0
  }
end

function love.mousepressed(x, y, button)
  if button == 1 then
    mouse.x1 = x
    mouse.y1 = y
  end

  if button == 2 then
    local position = LVector:new(x, y)
    target.position = position
  end
end

function love.mousereleased(x, y, button)
  if button == 1 then
    local x = math.min(mouse.x1, mouse.x2)
    local y = math.min(mouse.y1, mouse.y2)
    local width = math.abs(mouse.x1 - mouse.x2)
    local height = math.abs(mouse.y1 - mouse.y2)
    table.insert(obstacles, Obstacle:new(x, y, width, height))
  end
end

function love.update(dt)
  population:update(dt)

  if love.mouse.isDown(1) then
    local x, y = love.mouse:getPosition()
    mouse.x2 = x
    mouse.y2 = y
  end
end

function love.draw()
  for i, obstacle in ipairs(obstacles) do
    obstacle:render()
  end

  if love.mouse.isDown(1) then
    love.graphics.setColor(0.11, 0.11, 0.11, 1)
    love.graphics.setPointSize(MOUSE_POINT_SIZE)
    love.graphics.points(mouse.x1, mouse.y1, mouse.x2, mouse.y2)
    love.graphics.setLineWidth(MOUSE_LINE_WIDTH)
    love.graphics.line(mouse.x1, mouse.y1, mouse.x2, mouse.y1)
    love.graphics.line(mouse.x1, mouse.y1, mouse.x1, mouse.y2)
    love.graphics.line(mouse.x2, mouse.y1, mouse.x2, mouse.y2)
    love.graphics.line(mouse.x1, mouse.y2, mouse.x2, mouse.y2)
  end

  population:render()
  target:render()
end

function map(value, currentMin, currentMax, newMin, newMax)
  return (value - currentMin) / (currentMax - currentMin) * (newMax - newMin) + newMin
end
