require "Rectangle"

Windmill = {}
Windmill.__index = Windmill

function Windmill:new(world)
  local rectangleA =
    Rectangle:new(
    world,
    WINDOW_WIDTH / 2,
    WINDOW_HEIGHT - TERRAIN_HEIGHT - WINDMILL_HEIGHT / 2,
    WINDMILL_WIDTH,
    WINDMILL_HEIGHT,
    "static"
  )
  local rectangleB =
    Rectangle:new(
    world,
    WINDOW_WIDTH / 2,
    WINDOW_HEIGHT - TERRAIN_HEIGHT - WINDMILL_HEIGHT,
    BLADE_WIDTH,
    BLADE_HEIGHT,
    "dynamic"
  )

  local joint =
    love.physics.newRevoluteJoint(rectangleA.body, rectangleB.body, rectangleB.body:getX(), rectangleB.body:getY())

  joint:setMotorSpeed(MOTOR_SPEED)
  joint:setMotorEnabled(true)
  joint:setMaxMotorTorque(MAX_MOTOR_TORQUE)

  local this = {
    ["rectangles"] = {rectangleA, rectangleB},
    ["joint"] = joint
  }

  setmetatable(this, self)
  return this
end

function Windmill:render()
  love.graphics.setColor(0.11, 0.11, 0.11)

  for i, rectangle in ipairs(self.rectangles) do
    rectangle:render()
  end
end
