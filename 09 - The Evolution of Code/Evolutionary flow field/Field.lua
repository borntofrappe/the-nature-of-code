Field = {}
Field.__index = Field

function Field:new(grid, rows, columns)
  local this = {
    ["grid"] = grid,
    ["rows"] = rows,
    ["columns"] = columns
  }

  setmetatable(this, self)
  return this
end

function Field:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 0.25)
  love.graphics.setLineWidth(LINE_WIDTH_FLOW_FIELD)
  for r = 1, self.rows do
    for c = 1, self.columns do
      love.graphics.line(self.grid[r][c].x1, self.grid[r][c].y1, self.grid[r][c].x2, self.grid[r][c].y2)
    end
  end
end

function Field:lookup(x, y)
  local row = math.floor(y / self.rows) + 1
  local column = math.floor(x / self.columns) + 1
  return self.grid[row][column]
end
