require "Vector"

LVector = {}
LVector.__index = LVector

function LVector:init()
  local this = {}

  setmetatable(this, self)
  return this
end

function LVector:new(x, y)
  local vector = Vector:new(x, y)
  return vector
end

function LVector:add(v1, v2)
  local vector = Vector:new(0, 0)

  for k, value in pairs(vector) do
    vector[k] = v1[k] + v2[k]
  end

  return vector
end

function LVector:subtract(v1, v2)
  local vector = Vector:new(0, 0)

  for k, value in pairs(vector) do
    vector[k] = v1[k] - v2[k]
  end

  return vector
end

function LVector:multiply(v, s)
  local vector = Vector:new(0, 0)

  for k, value in pairs(vector) do
    vector[k] = v[k] * s
  end

  return vector
end

function LVector:divide(v, s)
  if s == 0 then
    return v
  else
    local vector = Vector:new(0, 0)

    for k, value in pairs(vector) do
      vector[k] = v[k] / s
    end

    return vector
  end
end

function LVector:dot(v1, v2)
  local product = 0

  for k, value in pairs(v1) do
    product = product + v1[k] * v2[k]
  end

  return product
end

function LVector:angleBetween(v1, v2)
  local d = self:dot(v1, v2)
  return math.acos(d / (v1:getMagnitude() * v2:getMagnitude()))
end

function LVector:copy(v)
  local vector = Vector:new(0, 0)

  for k, value in pairs(vector) do
    vector[k] = v[k]
  end

  return vector
end

return LVector:init()
