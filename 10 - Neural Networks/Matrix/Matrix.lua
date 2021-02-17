Matrix = {}
Matrix.__index = Matrix

function Matrix:new(rows, columns)
  local values = {}
  for r = 1, rows do
    values[r] = {}
    for c = 1, columns do
      values[r][c] = 0
    end
  end

  local this = {
    ["rows"] = rows,
    ["columns"] = columns,
    ["values"] = values
  }

  setmetatable(this, self)
  return this
end

function Matrix:add(input)
  if isInstance(input, self) then
    for r = 1, self.rows do
      for c = 1, self.columns do
        self.values[r][c] = self.values[r][c] + input.values[r][c]
      end
    end
  else
    for r = 1, self.rows do
      for c = 1, self.columns do
        self.values[r][c] = self.values[r][c] + input
      end
    end
  end
end

function Matrix:multiply(input)
  if isInstance(input, self) then
    for r = 1, self.rows do
      for c = 1, self.columns do
        self.values[r][c] = self.values[r][c] * input.values[r][c]
      end
    end
  else
    for r = 1, self.rows do
      for c = 1, self.columns do
        self.values[r][c] = self.values[r][c] * input
      end
    end
  end
end

function Matrix:getString()
  local v = {}

  for r = 1, self.rows do
    for c = 1, self.columns do
      table.insert(v, self.values[r][c] .. " ")
    end
    table.insert(v, "\n")
  end

  return table.concat(v)
end
