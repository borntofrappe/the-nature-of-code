Automaton = {}
Automaton.__index = Automaton

function Automaton:new()
  local grid = {}
  local columns = COLUMNS
  local rows = ROWS
  for column = 1, columns do
    grid[column] = {}
    for row = 1, rows do
      grid[column][row] = math.random() > 0.5
    end
  end

  local this = {
    ["grid"] = grid,
    ["columns"] = columns,
    ["rows"] = rows
  }

  setmetatable(this, self)
  return this
end

function Automaton:update()
  local grid = {}

  for column = 1, self.columns do
    grid[column] = {}
    for row = 1, self.rows do
      local aliveNeighbors = 0

      local c1 = math.max(1, column - 1)
      local c2 = math.min(self.columns, column + 1)

      local r1 = math.max(1, row - 1)
      local r2 = math.min(self.rows, row + 1)

      for c = c1, c2 do
        for r = r1, r2 do
          if self.grid[c][r] and (c ~= column or r ~= row) then
            aliveNeighbors = aliveNeighbors + 1
          end
        end
      end

      if self.grid[column][row] and aliveNeighbors < 2 then
        grid[column][row] = false
      elseif self.grid[column][row] and aliveNeighbors > 3 then
        grid[column][row] = false
      elseif not self.grid[column][row] and aliveNeighbors == 3 then
        grid[column][row] = true
      else
        grid[column][row] = self.grid[column][row]
      end
    end
  end

  self.grid = grid
end

function Automaton:toggle(column, row)
  self.grid[column][row] = not self.grid[column][row]
end

function Automaton:render()
  love.graphics.setLineWidth(LINE_WIDTH)
  love.graphics.setColor(0.11, 0.11, 0.11, 1)

  for column = 1, self.columns do
    love.graphics.line((column - 1) * CELL_SIZE, 0, (column - 1) * CELL_SIZE, WINDOW_HEIGHT)
  end

  for row = 1, self.rows do
    love.graphics.line(0, (row - 1) * CELL_SIZE, WINDOW_WIDTH, (row - 1) * CELL_SIZE)
  end

  for column = 1, self.columns do
    for row = 1, self.rows do
      if self.grid[column][row] then
        love.graphics.rectangle("fill", (column - 1) * CELL_SIZE, (row - 1) * CELL_SIZE, CELL_SIZE, CELL_SIZE)
      end
    end
  end
end
