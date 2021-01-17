WINDOW_WIDTH = 500
WINDOW_HEIGHT = 500
GRAVITY = 20
GRAVITY_METER = 9.81
METER = 100
RADIUS = 6
POINT_SIZE = 5
LINE_WIDTH = 1
TERRAIN_POINTS = 200
TERRAIN_HEIGHT = 50
JOINT_LENGTH = 30
MAX_MOTOR_TORQUE = 800
MOTOR_SPEED = math.pi * 2
WINDMILL_WIDTH = 12
WINDMILL_HEIGHT = 60
BLADE_WIDTH = 80
BLADE_HEIGHT = 10

require "Windmill"
require "PairShape"
require "Platform"
require "Terrain"

function love.load()
  love.window.setTitle("Physics Libraries - Box2D - Distance joint")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
  love.graphics.setBackgroundColor(1, 1, 1)

  math.randomseed(os.time())
  love.physics.setMeter(METER)
  world = love.physics.newWorld(0, GRAVITY * GRAVITY_METER)

  particles = {PairShape:new(world, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)}

  platforms = {}

  windmill = Windmill:new(world)

  terrain = Terrain:new(world)

  mouse = {
    ["isPressed"] = false,
    ["x1"] = 0,
    ["y1"] = 0,
    ["x2"] = 0,
    ["y2"] = 0
  }
end

function love.mousepressed(x, y, button)
  if button == 2 then
    mouse.isPressed = true
    mouse.x1 = x
    mouse.y1 = y
  end
  if button == 1 then
    table.insert(particles, PairShape:new(world, x, y))
  end
end

function love.mousereleased(x, y, button)
  if button == 2 then
    mouse.isPressed = false
    local x = math.min(mouse.x1, mouse.x2)
    local y = math.min(mouse.y1, mouse.y2)
    local width = math.abs(mouse.x1 - mouse.x2)
    local height = math.abs(mouse.y1 - mouse.y2)
    table.insert(platforms, Platform:new(world, x + width / 2, y + height / 2, width, height))
  end
end

function love.update(dt)
  world:update(dt)

  local x, y = love.mouse:getPosition()
  if x > 0 and x < WINDOW_WIDTH and y > 0 and y < WINDOW_HEIGHT then
    if mouse.isPressed then
      mouse.x2 = x
      mouse.y2 = y
    end

    if x < WINDOW_WIDTH / 2 then
      if windmill.joint:getMotorSpeed() > 0 then
        windmill.joint:setMotorSpeed(MOTOR_SPEED * -1)
      end
    else
      if windmill.joint:getMotorSpeed() < 0 then
        windmill.joint:setMotorSpeed(MOTOR_SPEED)
      end
    end
  end

  for i = #particles, 1, -1 do
    local isBelow = true
    for j = 1, #particles[i].circles do
      if particles[i].circles[j].body:getY() - RADIUS < WINDOW_HEIGHT then
        isBelow = false
        break
      end
    end
    if isBelow then
      for j = 1, #particles[i].circles do
        particles[i].circles[j].body:destroy()
      end
      table.remove(particles, i)
    end
  end
end

function love.draw()
  for i, particle in ipairs(particles) do
    particle:render()
  end

  for i, platform in ipairs(platforms) do
    platform:render()
  end

  terrain:render()

  windmill:render()

  if mouse.isPressed then
    love.graphics.setColor(0.11, 0.11, 0.11)
    love.graphics.setPointSize(POINT_SIZE)
    love.graphics.points(mouse.x1, mouse.y1, mouse.x2, mouse.y2)
    love.graphics.setLineWidth(LINE_WIDTH)
    love.graphics.line(mouse.x1, mouse.y1, mouse.x2, mouse.y1)
    love.graphics.line(mouse.x1, mouse.y1, mouse.x1, mouse.y2)
    love.graphics.line(mouse.x2, mouse.y1, mouse.x2, mouse.y2)
    love.graphics.line(mouse.x1, mouse.y2, mouse.x2, mouse.y2)
  end
end
