require "Circle"

PairShape = {}
PairShape.__index = PairShape

function PairShape:new(world, x, y)
  local angle = math.rad(math.random(360))
  local x1 = x + math.cos(angle) * JOINT_LENGTH / 2
  local y1 = y + math.sin(angle) * JOINT_LENGTH / 2
  local x2 = x + math.cos(angle + math.pi) * JOINT_LENGTH / 2
  local y2 = y + math.sin(angle + math.pi) * JOINT_LENGTH / 2

  local circleA = Circle:new(world, x1, y1)
  local circleB = Circle:new(world, x2, y2)

  local joint =
    love.physics.newDistanceJoint(
    circleA.body,
    circleB.body,
    circleA.body:getX(),
    circleA.body:getY(),
    circleB.body:getX(),
    circleB.body:getY()
  )
  joint:setFrequency(2)
  joint:setDampingRatio(0.2)

  local this = {
    ["circles"] = {circleA, circleB}
    -- ["joint"] = joint
  }

  setmetatable(this, self)
  return this
end

function PairShape:render()
  love.graphics.setColor(0.11, 0.11, 0.11)
  love.graphics.setLineWidth(LINE_WIDTH)
  love.graphics.line(
    self.circles[1].body:getX(),
    self.circles[1].body:getY(),
    self.circles[2].body:getX(),
    self.circles[2].body:getY()
  )

  for i, circle in ipairs(self.circles) do
    circle:render()
  end
end
