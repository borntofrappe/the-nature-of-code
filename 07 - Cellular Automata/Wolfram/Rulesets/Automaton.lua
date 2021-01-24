Automaton = {}
Automaton.__index = Automaton

function Automaton:new()
  local rule = math.random(MAX_RULE)

  local binaryRule = decimalToBinary(rule, 8)
  local ruleset = {}
  for i = 1, #binaryRule do
    local key = decimalToBinary(7 - (i - 1), 3)
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
    ["rule"] = rule,
    ["ruleset"] = ruleset,
    ["hasExpired"] = false
  }

  setmetatable(this, self)
  return this
end

function Automaton:update()
  local latestGeneration = self.generations[#self.generations]
  local generation = {}
  for i = 1, #latestGeneration do
    local key = ""

    for j = i - 1, i + 1 do
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
    self.hasExpired = true
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
