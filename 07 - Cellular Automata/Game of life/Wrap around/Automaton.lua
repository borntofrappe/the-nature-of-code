Automaton = {}
Automaton.__index = Automaton

function Automaton:new()
  local grid = {}
  local newGrid = {}
  local columns = COLUMNS
  local rows = ROWS
  for column = 1, columns do
    grid[column] = {}
    newGrid[column] = {}
    for row = 1, rows do
      grid[column][row] = math.random() > 0.5
      newGrid[column][row] = 0
    end
  end

  local this = {
    ["grid"] = grid,
    ["newGrid"] = newGrid,
    ["columns"] = columns,
    ["rows"] = rows
  }

  setmetatable(this, self)
  return this
end

function Automaton:update()
  for column = 1, self.columns do
    for row = 1, self.rows do
      local aliveNeighbors = 0

      for c = column - 1, column + 1 do
        local indexColumn = c
        if indexColumn < 1 then
          indexColumn = (indexColumn - 1) % self.columns + 1
        elseif indexColumn > self.columns then
          indexColumn = indexColumn % self.columns
        end
        for r = row - 1, row + 1 do
          local indexRow = r
          if indexRow < 1 then
            indexRow = (indexRow - 1) % self.rows + 1
          elseif indexRow > self.rows then
            indexRow = indexRow % self.rows
          end

          if self.grid[indexColumn][indexRow] and (indexColumn ~= column or indexRow ~= row) then
            aliveNeighbors = aliveNeighbors + 1
          end
        end
      end

      if self.grid[column][row] and aliveNeighbors < 2 then
        self.newGrid[column][row] = false
      elseif self.grid[column][row] and aliveNeighbors > 3 then
        self.newGrid[column][row] = false
      elseif not self.grid[column][row] and aliveNeighbors == 3 then
        self.newGrid[column][row] = true
      else
        self.newGrid[column][row] = self.grid[column][row]
      end
    end
  end

  for column = 1, self.columns do
    for row = 1, self.rows do
      self.grid[column][row] = self.newGrid[column][row]
    end
  end
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
