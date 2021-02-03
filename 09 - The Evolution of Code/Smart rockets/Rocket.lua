Rocket = {}
Rocket.__index = Rocket

function Rocket:new(dna)
  local position = LVector:new(ROCKET_X, ROCKET_Y)
  local velocity = LVector:new(0, 0)
  local acceleration = LVector:new(0, 0)

  local this = {
    ["dna"] = dna,
    ["position"] = position,
    ["velocity"] = velocity,
    ["acceleration"] = acceleration,
    ["maxSpeed"] = ROCKET_MAX_SPEED,
    ["maxForce"] = ROCKET_MAX_FORCE,
    ["size"] = ROCKET_SIZE,
    ["angle"] = 0
  }

  setmetatable(this, self)
  return this
end

function Rocket:update(dt, frame)
  self.velocity:add(LVector:multiply(self.acceleration, dt * UPDATE_SPEED))
  self.position:add(LVector:multiply(self.velocity, dt * UPDATE_SPEED))
  self.velocity:limit(self.maxSpeed)
  self.acceleration:multiply(0)
  self.angle = math.atan2(self.velocity.y, self.velocity.x)

  if self.position.x > WINDOW_WIDTH or self.position.x < 0 or self.position.y > WINDOW_HEIGHT or self.position.y < 0 then
    self.velocity:multiply(0)
  else
    self:applyForce(LVector:multiply(self.dna.genes[frame], dt * UPDATE_SPEED_ACCELERATION))
  end
end

function Rocket:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.push()
  love.graphics.translate(self.position.x, self.position.y)
  love.graphics.rotate(self.angle)
  love.graphics.polygon("fill", -self.size, -self.size, self.size, 0, -self.size, self.size)
  love.graphics.pop()
end

function Rocket:applyForce(force)
  self.acceleration:add(force)
end

function Rocket:getFitness(target)
  local fitness = 0
  local dir = LVector:subtract(target.position, self.position)
  local distance = dir:getMagnitude()

  local fitness = 1 / distance
  return fitness
end
