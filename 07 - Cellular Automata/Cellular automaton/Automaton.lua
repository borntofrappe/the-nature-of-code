Automaton = {}
Automaton.__index = Automaton

function Automaton:new()
  local generation = {}
  for i = 1, NEIGHBORS do
    local isAlive = math.random() > 0.5
    table.insert(generation, isAlive)
  end

  local generations = {generation}

  local this = {
    ["generations"] = generations
  }

  setmetatable(this, self)
  return this
end

function Automaton:update()
  local latestGeneration = self.generations[#self.generations]
  local generation = {}
  for i = 1, #latestGeneration do
    local aliveNeighbors = 0
    local start = math.max(1, i - 1)
    local finish = math.min(#latestGeneration, i + 1)
    for j = start, finish do
      if latestGeneration[j] and j ~= i then
        aliveNeighbors = aliveNeighbors + 1
      end
    end
    local isAlive = aliveNeighbors == 1

    table.insert(generation, isAlive)
  end

  table.insert(self.generations, generation)

  if #self.generations > WINDOW_HEIGHT / CELL_SIZE then
    table.remove(self.generations, 1)
  end
end

function Automaton:render()
  love.graphics.setLineWidth(LINE_WIDTH)
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  for i, generation in ipairs(self.generations) do
    for j, neighbor in ipairs(generation) do
      if neighbor then
        love.graphics.rectangle("fill", (j - 1) * CELL_SIZE, (i - 1) * CELL_SIZE, CELL_SIZE, CELL_SIZE)
      end
    end
  end
end
