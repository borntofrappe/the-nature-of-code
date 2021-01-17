Rectangle = {}
Rectangle.__index = Rectangle

function Rectangle:new(world, x, y, width, height, type)
  local body = love.physics.newBody(world, x, y, type)
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

function Rectangle:render()
  love.graphics.setColor(0.11, 0.11, 0.11)
  love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end
