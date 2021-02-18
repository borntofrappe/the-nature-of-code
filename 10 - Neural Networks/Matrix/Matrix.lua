Matrix = {}
Matrix.__index = Matrix

function Matrix:new(rows, columns)
  local values = {}
  for r = 1, rows do
    values[r] = {}
    for c = 1, columns do
      values[r][c] = math.random(MAX_VALUE)
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
    if input.rows == self.rows and input.columns == self.columns then
      -- element-wise sum
      for r = 1, self.rows do
        for c = 1, self.columns do
          self.values[r][c] = self.values[r][c] + input.values[r][c]
        end
      end
    end
  else
    -- scalar sum
    for r = 1, self.rows do
      for c = 1, self.columns do
        self.values[r][c] = self.values[r][c] + input
      end
    end
  end
end

function Matrix:multiply(input)
  if isInstance(input, self) then
    if input.rows == self.columns and input.columns == self.rows then
      -- matrix product
      local values = {}
      local rows = self.rows
      local columns = input.columns

      for r = 1, rows do
        values[r] = {}
        for c = 1, columns do
          local value = 0
          -- self.columns or input.rows
          for i = 1, self.columns do
            value = value + (self.values[r][i] * input.values[i][c])
          end
          values[r][c] = value
        end
      end

      self.values = values
      self.rows = rows
      self.columns = columns
    elseif input.rows == self.rows and input.columns == self.columns then
      -- hadamard product, element by element
      for r = 1, self.rows do
        for c = 1, self.columns do
          self.values[r][c] = self.values[r][c] * input.values[r][c]
        end
      end
    end
  else
    -- scalar product
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
