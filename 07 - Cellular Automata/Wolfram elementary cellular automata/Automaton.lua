Automaton = {}
Automaton.__index = Automaton

function Automaton:new(rule)
  local ruleset = decimalToBinary(rule, 8)
  local options = {}
  for i = 1, #ruleset do
    local key = decimalToBinary(7 - (i - 1), 3)
    options[key] = math.floor(ruleset:sub(i, i))
  end

  local generation = {}
  for i = 1, NEIGHBORS do
    table.insert(generation, 0)
  end
  generation[math.ceil(#generation / 2)] = 1

  local generations = {generation}

  local this = {
    ["generations"] = generations,
    ["options"] = options
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
      if j == 0 or j == #latestGeneration + 1 then
        key = key .. 0
      else
        key = key .. latestGeneration[j]
      end
    end

    table.insert(generation, self.options[key])
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
      if cell == 1 then
        love.graphics.rectangle("fill", (j - 1) * CELL_SIZE, 0, CELL_SIZE, CELL_SIZE)
      end
    end
    love.graphics.pop()
  end
end
