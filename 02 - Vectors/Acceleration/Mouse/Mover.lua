Mover = {}
Mover.__index = Mover

function Mover:new()
  local position = LVector:new(math.random(WINDOW_WIDTH), math.random(WINDOW_HEIGHT))

  local velocity = LVector:new(0, 0)

  local acceleration = LVector:new(0, 0)

  local this = {
    ["position"] = position,
    ["velocity"] = velocity,
    ["acceleration"] = acceleration,
    ["r"] = RADIUS
  }

  setmetatable(this, self)
  return this
end

function Mover:update(dt)
  self.position:add(LVector:multiply(self.velocity, dt))
  self.velocity:add(LVector:multiply(self.acceleration, dt))
  self.velocity:limit(VELOCITY_UPPER_THRESHOLD)

  local x, y = love.mouse:getPosition()
  if x > 0 and y > 0 then
    local distance = LVector:new(x, y)
    distance:subtract(self.position)
    distance:normalize()
    distance:multiply(ACCELERATION)
    self.acceleration = distance
  end
end

function Mover:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.circle("fill", self.position.x, self.position.y, self.r)
end
