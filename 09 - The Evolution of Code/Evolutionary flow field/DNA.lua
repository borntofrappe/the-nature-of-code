DNA = {}
DNA.__index = DNA

function DNA:new(length)
  local genes = {}

  for i = 1, length do
    table.insert(genes, math.random())
  end

  local this = {
    ["genes"] = genes
  }

  setmetatable(this, self)
  return this
end

function DNA:getField()
  local grid = {}

  local columns = math.floor(WINDOW_WIDTH / RESOLUTION_FLOW_FIELD)
  local rows = math.floor(WINDOW_HEIGHT / RESOLUTION_FLOW_FIELD)
  local cellWidth = (WINDOW_WIDTH / columns)
  local cellHeight = (WINDOW_HEIGHT / rows)
  for row = 1, rows do
    grid[row] = {}
    for column = 1, columns do
      local index = row + (column - 1) * rows
      local angle = map(self.genes[index], 0, 1, 0, math.pi * 2)
      local x1 = math.cos(angle + math.pi) * math.min(cellWidth, cellHeight) / 2.5
      local y1 = math.sin(angle + math.pi) * math.min(cellWidth, cellHeight) / 2.5
      local x2 = math.cos(angle) * math.min(cellWidth, cellHeight) / 2.5
      local y2 = math.sin(angle) * math.min(cellWidth, cellHeight) / 2.5
      local force = LVector:new(x2 - x1, y2 - y1)
      grid[row][column] = {
        ["angle"] = angle,
        ["x1"] = x1 + (column - 1) * cellWidth + cellWidth / 2,
        ["y1"] = y1 + (row - 1) * cellHeight + cellHeight / 2,
        ["x2"] = x2 + (column - 1) * cellWidth + cellWidth / 2,
        ["y2"] = y2 + (row - 1) * cellHeight + cellHeight / 2,
        ["force"] = force
      }
    end
  end

  local field = Field:new(grid, rows, columns)

  return field
end

function DNA:inherit(parent1, parent2, mutationOdds)
  local genes = {}
  for i = 1, #self.genes do
    if math.random(mutationOdds) ~= 1 then
      self.genes[i] = i % 2 == 0 and parent1.dna.genes[i] or parent2.dna.genes[i]
    end
  end
end
