require "Line"
Tree = {}
Tree.__index = Tree

function Tree:new()
  local angle = ANGLE
  local lengthInitial = LENGTH_INITIAL
  local lengthMin = LENGTH_MIN
  local lengthMultiplier = LENGTH_MULTIPLIER
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
    ["angle"] = angle,
    ["lengthMin"] = lengthMin,
    ["lengthMultiplier"] = lengthMultiplier,
    ["lineWidthMin"] = lineWidthMin,
    ["lineWidthChange"] = lineWidthChange
  }

  setmetatable(this, self)
  return this
end

function Tree:generate()
  local latestGeneration = self.generations[#self.generations]
  local length = latestGeneration.length
  local lineWidth = latestGeneration.lineWidth

  if length > self.lengthMin then
    length = length * self.lengthMultiplier
    lineWidth = math.max(self.lineWidthMin, lineWidth - self.lineWidthChange)
    local generation = {
      ["length"] = length,
      ["lineWidth"] = lineWidth,
      ["lines"] = {}
    }

    for i, line in ipairs(latestGeneration.lines) do
      local start = LVector:copy(line.finish)
      local finish1 = LVector:new(0, -length)
      local angle1 = line.angle + self.angle
      finish1:rotate(angle1)
      finish1:add(start)
      table.insert(generation.lines, Line:new(start, finish1, angle1))

      local finish2 = LVector:new(0, -length)
      local angle2 = line.angle - self.angle
      finish2:rotate(angle2)
      finish2:add(start)
      table.insert(generation.lines, Line:new(start, finish2, angle2))
    end

    table.insert(self.generations, generation)
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
