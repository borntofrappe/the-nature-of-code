Blob = {}
Blob.__index = Blob

function Blob:new(x, y, r)
  local x = x or math.random(0, WINDOW_WIDTH)
  local y = y or math.random(0, WINDOW_HEIGHT)
  local r = r or math.random(BLOB_RADIUS_MIN, BLOB_RADIUS_MAX)

  local lifespan = BLOB_LIFESPAN
  local offset = math.random(BLOB_OFFSET_INITIAL_MAX)
  local offsetIncrement =
    math.random() * (BLOB_OFFSET_INCREMENT_MAX - BLOB_OFFSET_INCREMENT_MIN) + BLOB_OFFSET_INCREMENT_MIN

  local updateSpeed =
    map(r, BLOB_RADIUS_MIN, BLOB_RADIUS_MAX, BLOB_MOVEMENT_UPDATE_SPEED_MAX, BLOB_MOVEMENT_UPDATE_SPEED_MIN)
  local this = {
    ["x"] = x,
    ["y"] = y,
    ["r"] = r,
    ["lifespan"] = lifespan,
    ["offset"] = offset,
    ["offsetIncrement"] = offsetIncrement,
    ["updateSpeed"] = updateSpeed
  }

  setmetatable(this, self)
  return this
end

function Blob:update(dt)
  self.x = self.x + (love.math.noise(self.offset) - 0.5) * dt * self.updateSpeed
  self.y = self.y + (love.math.noise(self.offset + BLOB_OFFSET_DISTANCE) - 0.5) * dt * self.updateSpeed
  self.offset = self.offset + self.offsetIncrement

  self.lifespan = math.max(0, self.lifespan - dt * BLOB_LIFESPAN_UPDATE_SPEED)

  if self.x > WINDOW_WIDTH then
    self.x = 0
  elseif self.x < 0 then
    self.x = WINDOW_WIDTH
  end
  if self.y > WINDOW_HEIGHT then
    self.y = 0
  elseif self.y < 0 then
    self.y = WINDOW_HEIGHT
  end
end

function Blob:render()
  love.graphics.setColor(0.11, 0.11, 0.11, self.lifespan)
  love.graphics.circle("fill", self.x, self.y, self.r)
end
