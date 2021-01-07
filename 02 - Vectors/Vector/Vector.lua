Vector = {}
Vector.__index = Vector

function Vector:new(x, y)
  this = {
    ["x"] = x,
    ["y"] = y
  }

  setmetatable(this, self)
  return this
end
