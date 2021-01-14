Vector = {}
Vector.__index = Vector

function Vector:new(x, y)
  local this = {
    ["x"] = x,
    ["y"] = y
  }

  setmetatable(this, self)
  return this
end

function Vector:add(v)
  for k, value in pairs(self) do
    self[k] = value + v[k]
  end
end

function Vector:subtract(v)
  for k, value in pairs(self) do
    self[k] = value - v[k]
  end
end

function Vector:multiply(s)
  for k, value in pairs(self) do
    self[k] = value * s
  end
end

function Vector:divide(s)
  if s ~= 0 then
    for k, value in pairs(self) do
      self[k] = value / s
    end
  end
end

function Vector:getMagnitude()
  local total = 0

  for k, value in pairs(self) do
    total = total + value ^ 2
  end

  return total ^ 0.5
end

function Vector:normalize()
  local magnitude = self:getMagnitude()

  self:divide(magnitude)
end

function Vector:limit(m)
  local magnitude = self:getMagnitude()

  if magnitude > m then
    self:normalize()
    self:multiply(m)
  end
end
