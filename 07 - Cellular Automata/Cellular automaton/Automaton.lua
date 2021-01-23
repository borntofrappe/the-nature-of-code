Automaton = {}
Automaton.__index = Automaton

function Automaton:new()
  local generation = {}
  for i = 1, NEIGHBORS do
    local x = (i - 1) * CELL_SIZE
    local y = 0
    local isAlive = math.random() > 0.5
    table.insert(
      generation,
      {
        ["x"] = x,
        ["isAlive"] = isAlive
      }
    )
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
    local x = latestGeneration[i].x
    local wasAlive = latestGeneration[i].isAlive
    local neighbors = {}
    if i > 1 then
      table.insert(neighbors, latestGeneration[i - 1])
    end
    if i < #latestGeneration then
      table.insert(neighbors, latestGeneration[i + 1])
    end

    local aliveCount = 0
    for j, neighbor in ipairs(neighbors) do
      if neighbor.isAlive then
        aliveCount = aliveCount + 1
      end
    end

    local isAlive = aliveCount == 1

    table.insert(
      generation,
      {
        ["x"] = x,
        ["y"] = y,
        ["isAlive"] = isAlive
      }
    )
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
    love.graphics.push()
    love.graphics.translate(0, (i - 1) * CELL_SIZE)
    for j, cell in ipairs(generation) do
      if cell.isAlive then
        love.graphics.rectangle("fill", cell.x, 0, CELL_SIZE, CELL_SIZE)
      else
        love.graphics.rectangle("line", cell.x, 0, CELL_SIZE, CELL_SIZE)
      end
    end
    love.graphics.pop()
  end
end
