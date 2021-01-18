WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
GRAVITY = 20
GRAVITY_METER = 9.81
METER = 100
RADIUS = 10
LINE_WIDTH = 1
RESTITUTION = 0.75
JOINT_FREQUENCY = 3
JOINT_DAMPING_RATIO = 0.1
WALL_WIDTH_LEFT_RIGHT = 10
WALL_HEIGHT_TOP_BOTTOM = 10

require "Circle"
require "Rectangle"

function love.load()
  love.window.setTitle("Physics Libraries - Box2D - Joint - Mouse")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())
  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, GRAVITY * GRAVITY_METER)

  local leftWall = Rectangle:new(world, 0, WINDOW_HEIGHT / 2, WALL_WIDTH_LEFT_RIGHT, WINDOW_HEIGHT, "static")
  local rightWall =
    Rectangle:new(world, WINDOW_WIDTH, WINDOW_HEIGHT / 2, WALL_WIDTH_LEFT_RIGHT, WINDOW_HEIGHT, "static")
  local topWall = Rectangle:new(world, WINDOW_WIDTH / 2, 0, WINDOW_WIDTH, WALL_HEIGHT_TOP_BOTTOM, "static")
  local bottomWall =
    Rectangle:new(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT, WINDOW_WIDTH, WALL_HEIGHT_TOP_BOTTOM, "static")
  walls = {leftWall, rightWall, topWall, bottomWall}

  circle = Circle:new(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
  circle.fixture:setRestitution(RESTITUTION)

  joint = nil
end

function love.mousepressed(x, y, button)
  if button == 1 then
    if not joint then
      joint = love.physics.newMouseJoint(circle.body, x, y)
      joint:setFrequency(JOINT_FREQUENCY)
      joint:setDampingRatio(JOINT_DAMPING_RATIO)
    end
  end
end

function love.mousereleased(x, y, button)
  if button == 1 then
    if joint then
      joint:destroy()
      joint = nil
    end
  end
end

function love.update(dt)
  world:update(dt)

  if love.mouse.isDown(1) then
    if not joint:isDestroyed() then
      local x, y = love.mouse:getPosition()
      joint:setTarget(x, y)
    end
  end
end

function love.draw()
  for i, wall in ipairs(walls) do
    wall:render()
  end

  circle:render()

  if love.mouse.isDown(1) then
    local x, y = love.mouse:getPosition()
    love.graphics.setColor(0.11, 0.11, 0.11)
    love.graphics.setLineWidth(LINE_WIDTH)
    love.graphics.circle("fill", x, y, RADIUS / 2)
    love.graphics.line(x, y, circle.body:getX(), circle.body:getY())
  end
end
