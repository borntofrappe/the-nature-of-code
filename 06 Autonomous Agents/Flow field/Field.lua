Field = {}
Field.__index = Field

function Field:new(position)
  local grid = {}
  local columns = math.floor(WINDOW_WIDTH / RESOLUTION)
  local rows = math.floor(WINDOW_HEIGHT / RESOLUTION)
  local width = (WINDOW_WIDTH / columns)
  local height = (WINDOW_HEIGHT / rows)
  for row = 1, rows do
    grid[row] = {}
    for column = 1, columns do
      local angle = math.rad(math.random(360))
      local x1 = math.cos(angle + math.pi) * math.min(width, height) / 2.5
      local y1 = math.sin(angle + math.pi) * math.min(width, height) / 2.5
      local x2 = math.cos(angle) * math.min(width, height) / 2.5
      local y2 = math.sin(angle) * math.min(width, height) / 2.5
      local force = LVector:new(x2 - x1, y2 - y1)
      grid[row][column] = {
        ["angle"] = angle,
        ["x1"] = x1 + (column - 1) * width + width / 2,
        ["y1"] = y1 + (row - 1) * height + height / 2,
        ["x2"] = x2 + (column - 1) * width + width / 2,
        ["y2"] = y2 + (row - 1) * height + height / 2,
        ["force"] = force
      }
    end
  end

  local this = {
    ["grid"] = grid,
    ["rows"] = rows,
    ["columns"] = columns
  }

  setmetatable(this, self)
  return this
end

function Field:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 0.5)
  love.graphics.setLineWidth(LINE_WIDTH_FIELD)
  for r = 1, self.rows do
    for c = 1, self.columns do
      love.graphics.line(self.grid[r][c].x1, self.grid[r][c].y1, self.grid[r][c].x2, self.grid[r][c].y2)
    end
  end
end

function Field:lookup(x, y)
  return math.floor(x / self.columns) + 1, math.floor(y / self.rows) + 1
end
