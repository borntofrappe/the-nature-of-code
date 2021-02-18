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

-- functions returning a new matrix
function Matrix.Add(m1, m2)
  if m1.rows == m2.rows and m1.columns == m2.columns then
    local m = Matrix:new(m1.rows, m1.columns)

    for r = 1, m.rows do
      for c = 1, m.columns do
        m.values[r][c] = m1.values[r][c] + m2.values[r][c]
      end
    end

    return m
  end
end

function Matrix.Multiply(m1, m2)
  if m2.rows == m1.columns and m2.columns == m1.rows then
    local m = Matrix:new(m1.rows, m2.columns)

    for r = 1, m.rows do
      for c = 1, m.columns do
        local value = 0
        for i = 1, m.columns do
          value = value + (m1.values[r][i] * m2.values[i][c])
        end
        m.values[r][c] = value
      end
    end

    return m
  elseif m1.rows == m2.rows and m1.columns == m2.columns then
    local m = Matrix:new(m1.rows, m1.columns)

    for r = 1, m.rows do
      for c = 1, m.columns do
        m.values[r][c] = m1.values[r][c] * m2.values[r][c]
      end
    end

    return m
  end
end

-- functions modifying the input matrix
function Matrix:randomize(max)
  for r = 1, self.rows do
    for c = 1, self.columns do
      self.values[r][c] = math.random(max)
    end
  end
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

function Matrix:map(callback)
  for r = 1, self.rows do
    for c = 1, self.columns do
      self.values[r][c] = callback(self.values[r][c])
    end
  end
end

function Matrix:transpose()
  local values = {}
  local rows = self.columns
  local columns = self.rows

  for r = 1, rows do
    values[r] = {}
    for c = 1, columns do
      values[r][c] = self.values[c][r]
    end
  end

  self.values = values
  self.rows = rows
  self.columns = columns
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
