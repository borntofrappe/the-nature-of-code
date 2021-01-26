require "Line"
Tree = {}
Tree.__index = Tree

function Tree:new()
  local tree = self:init()
  tree:generate()
  return tree
end

function Tree:init()
  local lengthInitial = LENGTH_INITIAL
  local lengthMin = LENGTH_MIN
  local angleMin = ANGLE_MIN
  local angleMax = ANGLE_MAX
  local lengthMultiplierMin = LENGTH_MULTIPLIER_MIN
  local lengthMultiplierMax = LENGTH_MULTIPLIER_MAX
  local lineWidthMax = LINEWIDTH_MAX
  local lineWidthMin = LINEWIDTH_MIN
  local lineWidthChange = LINEWIDTH_CHANGE

  local start = LVector:new(WINDOW_WIDTH / 2, WINDOW_HEIGHT)
  local finish = LVector:new(WINDOW_WIDTH / 2, WINDOW_HEIGHT - lengthInitial)
  local line = Line:new(start, finish)

  local generation = {
    ["length"] = lengthInitial,
    ["lineWidth"] = lineWidthMax,
    ["lines"] = {line}
  }
  local generations = {generation}
  local this = {
    ["generations"] = generations,
    ["angleMin"] = angleMin,
    ["angleMax"] = angleMax,
    ["lengthMin"] = lengthMin,
    ["lengthMultiplierMin"] = lengthMultiplierMin,
    ["lengthMultiplierMax"] = lengthMultiplierMax,
    ["lineWidthMin"] = lineWidthMin,
    ["lineWidthChange"] = lineWidthChange
  }

  setmetatable(this, self)
  return this
end

function Tree:generate()
  local latestGeneration = self.generations[#self.generations]
  local lineWidth = latestGeneration.lineWidth

  if lineWidth > self.lineWidthMin then
    lineWidth = math.max(self.lineWidthMin, lineWidth ^ 0.8)
    local generation = {
      ["lineWidth"] = lineWidth,
      ["lines"] = {}
    }

    for i, line in ipairs(latestGeneration.lines) do
      local lengthMultiplier =
        math.random() * (self.lengthMultiplierMax - self.lengthMultiplierMin) + self.lengthMultiplierMin
      local angle = math.random() * (self.angleMax - self.angleMin) + self.angleMin
      local dir = LVector:subtract(line.finish, line.start)
      local length = dir:getMagnitude() * lengthMultiplier

      local start = LVector:copy(line.finish)
      local finish1 = LVector:new(0, -length)
      local angle1 = line.angle + angle
      finish1:rotate(angle1)
      finish1:add(start)
      table.insert(generation.lines, Line:new(start, finish1, angle1))

      local finish2 = LVector:new(0, -length)
      local angle2 = line.angle - angle
      finish2:rotate(angle2)
      finish2:add(start)
      table.insert(generation.lines, Line:new(start, finish2, angle2))
    end

    table.insert(self.generations, generation)

    self:generate()
  end
end

function Tree:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  for i, generation in ipairs(self.generations) do
    love.graphics.setLineWidth(generation.lineWidth)
    for j, line in ipairs(generation.lines) do
      line:render()
    end
  end
end
