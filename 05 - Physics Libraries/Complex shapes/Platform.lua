Platform = {}
Platform.__index = Platform

function Platform:new(world, x, y, width, height)
  local body = love.physics.newBody(world, x, y, "static")
  local shape = love.physics.newRectangleShape(width, height)
  local fixture = love.physics.newFixture(body, shape)

  local this = {
    ["body"] = body,
    ["shape"] = shape,
    ["fixture"] = fixture
  }

  setmetatable(this, self)
  return this
end

function Platform:render()
  love.graphics.setColor(0.11, 0.11, 0.11)
  love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end
