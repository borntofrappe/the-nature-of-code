Vector = {}
Vector.__index = Vector

function Vector:init()
  this = {}

  setmetatable(this, self)
  return this
end

function Vector:new(x, y)
  local vector = {
    ["x"] = x,
    ["y"] = y
  }

  return vector
end

function Vector:add(v1, v2)
  local vector = self:new(0, 0)

  for k, value in pairs(vector) do
    vector[k] = v1[k] + v2[k]
  end

  return vector
end

function Vector:subtract(v1, v2)
  local vector = self:new(0, 0)

  for k, value in pairs(vector) do
    vector[k] = v2[k] - v1[k]
  end

  return vector
end

function Vector:multiply(v, s)
  local vector = self:new(0, 0)

  for k, value in pairs(vector) do
    vector[k] = v[k] * s
  end

  return vector
end

function Vector:divide(v, s)
  if s == 0 then
    return nil
  else
    local vector = self:new(0, 0)
    for k, value in pairs(vector) do
      vector[k] = v[k] / s
    end

    return vector
  end
end

function Vector:magnitude(v)
  local total = 0

  for k, value in pairs(v) do
    total = value ^ 2
  end

  return total ^ 0.5
end

return Vector:init()
