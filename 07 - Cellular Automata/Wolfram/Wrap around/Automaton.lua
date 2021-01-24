Automaton = {}
Automaton.__index = Automaton

function Automaton:new(rule, neighborsBefore, neighborsAfter)
  local digits = neighborsAfter + neighborsBefore + 1
  local binaryMax = ""
  for i = 1, digits do
    binaryMax = binaryMax .. 1
  end
  local lengthMax = binaryToDecimal(binaryMax)

  local binaryRule = decimalToBinary(rule, lengthMax + 1)
  local ruleset = {}
  for i = 1, #binaryRule do
    local key = decimalToBinary(lengthMax - (i - 1), digits)
    ruleset[key] = math.floor(binaryRule:sub(i, i))
  end

  local generation = {}
  for i = 1, NEIGHBORS do
    table.insert(generation, 0)
  end
  generation[math.ceil(#generation / 2)] = 1

  local generations = {generation}

  local this = {
    ["generations"] = generations,
    ["ruleset"] = ruleset,
    ["neighborsBefore"] = neighborsBefore,
    ["neighborsAfter"] = neighborsAfter
  }

  setmetatable(this, self)
  return this
end

function Automaton:update()
  local latestGeneration = self.generations[#self.generations]
  local generation = {}
  for i = 1, #latestGeneration do
    local key = ""

    for j = i - self.neighborsBefore, i + self.neighborsAfter do
      local index = j
      if index < 1 then
        -- index = index + #latestGeneration
        index = (index - 1) % #latestGeneration + 1
      end
      if index > #latestGeneration then
        -- index = index + #latestGeneration
        index = index % #latestGeneration
      end
      key = key .. latestGeneration[index]
    end

    table.insert(generation, self.ruleset[key])
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
    for j, cell in ipairs(generation) do
      if cell == 1 then
        love.graphics.rectangle("fill", (j - 1) * CELL_SIZE, (i - 1) * CELL_SIZE, CELL_SIZE, CELL_SIZE)
      end
    end
  end
end
