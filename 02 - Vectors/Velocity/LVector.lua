require "Vector"

LVector = {}
LVector.__index = LVector

function LVector:init()
  this = {}

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
    -- throw error
  else
    local vector = Vector:new(0, 0)

    for k, value in pairs(vector) do
      vector[k] = v[k] / s
    end

    return vector
  end
end

return LVector:init()
