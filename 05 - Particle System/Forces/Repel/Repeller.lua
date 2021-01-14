Repeller = {}
Repeller.__index = Repeller

function Repeller:new(x, y)
  local position = LVector:new(x, y)

  local this = {
    ["position"] = position,
    ["mass"] = 1
  }

  setmetatable(this, self)
  return this
end

function Repeller:update(dt)
end

function Repeller:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.circle("fill", self.position.x, self.position.y, RADIUS_REPELLER)
end

function Repeller:repel(particle)
  local force = LVector:new(0, 0)
  local direction = LVector:subtract(self.position, particle.position)
  local distance = direction:getMagnitude()
  if math.abs(distance) > RADIUS_REPELLER + RADIUS_PARTICLE + PADDING_REPELLER then
    return LVector:new(0, 0)
  end
  return LVector:multiply(direction, REPULSION_FORCE * -1)
end
