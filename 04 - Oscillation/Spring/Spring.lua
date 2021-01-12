Spring = {}
Spring.__index = Spring

function Spring:new(x, y, restLength)
  local anchor = LVector:new(x, y)
  local location = LVector:new(0, restLength)

  this = {
    ["anchor"] = anchor,
    ["location"] = location,
    ["restLength"] = restLength
  }

  setmetatable(this, self)
  return this
end

function Spring:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.setLineWidth(ARM_LINE_WIDTH)
  love.graphics.circle("fill", self.anchor.x, self.anchor.y, PIVOT_RADIUS)
  love.graphics.line(self.anchor.x, self.anchor.y, self.location.x, self.location.y)
end

function Spring:connect(bob)
  local direction = LVector:subtract(bob.position, self.anchor)
  local currentLength = direction:getMagnitude()
  local displacement = currentLength - self.restLength

  direction:normalize()
  local spring = LVector:multiply(direction, K * -1 * displacement)
  bob:applyForce(spring)

  self.location = LVector:copy(bob.position)
end
