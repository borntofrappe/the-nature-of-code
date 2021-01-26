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
    ["lineWidthMin"] = lineWidthMin
  }

  setmetatable(this, self)
  return this
end

function Tree:generate()
  local latestGeneration = self.generations[#self.generations]
  local lineWidth = latestGeneration.lineWidth

  if lineWidth > self.lineWidthMin then
    lineWidth = math.max(self.lineWidthMin, lineWidth ^ 0.7)
    local generation = {
      ["lineWidth"] = lineWidth,
      ["lines"] = {}
    }

    for i, line in ipairs(latestGeneration.lines) do
      local dir = LVector:subtract(line.finish, line.start)
      local length = dir:getMagnitude()
      local start = LVector:copy(line.finish)
      local angle = line.angle

      local branches = math.random(BRANCHES_MIN, BRANCHES_MAX)
      for j = 1, branches do
        local lengthMultiplier =
          math.random() * (self.lengthMultiplierMax - self.lengthMultiplierMin) + self.lengthMultiplierMin
        local lineAngle = math.random() * (self.angleMax - self.angleMin) + self.angleMin
        if math.random() > 0.5 then
          lineAngle = lineAngle * -1
        end
        lineAngle = lineAngle + angle
        local lineLength = length * lengthMultiplier

        local finish = LVector:new(0, -lineLength)
        finish:rotate(lineAngle)
        finish:add(start)
        table.insert(generation.lines, Line:new(start, finish, lineAngle))
      end
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
