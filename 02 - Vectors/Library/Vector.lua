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

return Vector:init()
