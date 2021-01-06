Library = {}
Library.__index = Library

function Library:new()
  this = {}

  setmetatable(this, self)
  return this
end

function Library:newVector(x, y)
  local vector = {
    ["x"] = x,
    ["y"] = y
  }

  return vector
end

return Library:new()
