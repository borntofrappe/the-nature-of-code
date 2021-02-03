Bloop = {}
Bloop.__index = Bloop

function Bloop:new(x, y, r)
  local x = x or math.random(0, WINDOW_WIDTH)
  local y = y or math.random(0, WINDOW_HEIGHT)
  local r = r or math.random(BLOOP_RADIUS_MIN, BLOOP_RADIUS_MAX)

  local position = LVector:new(x, y)
  local velocity = LVector:new(0, 0)

  local lifespan = BLOOP_LIFESPAN
  local offset = math.random(BLOOP_OFFSET_INITIAL_MAX)
  local offsetIncrement =
    math.random() * (BLOOP_OFFSET_INCREMENT_MAX - BLOOP_OFFSET_INCREMENT_MIN) + BLOOP_OFFSET_INCREMENT_MIN

  local movementUpdateSpeed =
    map(r, BLOOP_RADIUS_MIN, BLOOP_RADIUS_MAX, BLOOP_MOVEMENT_UPDATE_SPEED_MAX, BLOOP_MOVEMENT_UPDATE_SPEED_MIN)

  local lifespanUpdateSpeed = BLOOP_LIFESPAN_UPDATE_SPEED
  local this = {
    ["position"] = position,
    ["velocity"] = velocity,
    ["r"] = r,
    ["lifespan"] = lifespan,
    ["offset"] = offset,
    ["offsetIncrement"] = offsetIncrement,
    ["movementUpdateSpeed"] = movementUpdateSpeed,
    ["lifespanUpdateSpeed"] = lifespanUpdateSpeed
  }

  setmetatable(this, self)
  return this
end

function Bloop:update(dt)
  self.position:add(self.velocity)

  local x = (love.math.noise(self.offset) - 0.5) * dt * self.movementUpdateSpeed
  local y = (love.math.noise(self.offset + BLOOP_OFFSET_DISTANCE) - 0.5) * dt * self.movementUpdateSpeed
  local velocity = LVector:new(x, y)
  self.velocity:add(velocity)
  self.offset = self.offset + self.offsetIncrement

  self.lifespan = math.max(0, self.lifespan - dt * self.lifespanUpdateSpeed)

  if self.position.x > WINDOW_WIDTH then
    self.position.x = 0
  elseif self.position.x < 0 then
    self.position.x = WINDOW_WIDTH
  end
  if self.position.y > WINDOW_HEIGHT then
    self.position.y = 0
  elseif self.position.y < 0 then
    self.position.y = WINDOW_HEIGHT
  end
end

function Bloop:render()
  love.graphics.setColor(0.11, 0.11, 0.11, self.lifespan)
  love.graphics.circle("fill", self.position.x, self.position.y, self.r)
end

function Bloop:collides(pellet)
  return (pellet.x + pellet.size / 2 - self.position.x) ^ 2 + (pellet.y + pellet.size / 2 - self.position.y) ^ 2 <
    (pellet.size + self.r) ^ 2
end

function Bloop:increaseLifespan()
  self.lifespan = math.min(BLOOP_LIFESPAN, self.lifespan + BLOOP_LIFESPAN_INCREMENT)
end
