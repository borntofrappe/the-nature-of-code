Vehicle = {}
Vehicle.__index = Vehicle

function Vehicle:new()
  local position = LVector:new(X_VEHICLE, Y_VEHICLE)
  local velocity = LVector:new(0, 0)
  local acceleration = LVector:new(0, 0)
  local field = Field:new()
  local this = {
    ["position"] = position,
    ["velocity"] = velocity,
    ["acceleration"] = acceleration,
    ["maxSpeed"] = MAX_SPEED_VEHICLE,
    ["maxForce"] = MAX_FORCE_VEHICLE,
    ["size"] = SIZE_VEHICLE,
    ["angle"] = 0,
    ["field"] = field
  }

  setmetatable(this, self)
  return this
end

function Vehicle:update(dt)
  self.position:add(LVector:multiply(self.velocity, dt * UPDATE_SPEED))
  self.velocity:add(LVector:multiply(self.acceleration, dt * UPDATE_SPEED))
  self.velocity:limit(self.maxSpeed)
  self.acceleration:multiply(0)
  self.angle = math.atan2(self.velocity.y, self.velocity.x)

  if self.position.x > WINDOW_WIDTH or self.position.x < 0 or self.position.y > WINDOW_HEIGHT or self.position.y < 0 then
    self.velocity:multiply(0)
  else
    self:navigateField()
  end
end

function Vehicle:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.push()
  love.graphics.translate(self.position.x, self.position.y)
  love.graphics.rotate(self.angle)
  love.graphics.polygon("fill", -self.size, -self.size, self.size, 0, -self.size, self.size)
  love.graphics.pop()
end

function Vehicle:applyForce(force)
  self.acceleration:add(force)
end

function Vehicle:navigateField()
  local force = self.field:lookup(self.position.x, self.position.y).force
  force:limit(self.maxForce)
  self:applyForce(force)
end

function Vehicle:getFitness(target)
  local fitness = 0
  local dir = LVector:subtract(target.position, self.position)
  local distance = math.min(MAX_DISTANCE_VEHICLE, dir:getMagnitude())

  local fitness = map(distance, 0, MAX_DISTANCE_VEHICLE, MAX_FITNESS, MIN_FITNESS)

  return fitness
end

function Vehicle:inherit(parent1, parent2, mutationOdds)
  for r = 1, self.field.rows do
    for c = 1, self.field.columns do
      if math.random(mutationOdds) ~= 1 then
        if (c + r) % 2 == 0 then
          self.field.grid[r][c] = parent1.field.grid[r][c]
        else
          self.field.grid[r][c] = parent2.field.grid[r][c]
        end
      end
    end
  end
end
