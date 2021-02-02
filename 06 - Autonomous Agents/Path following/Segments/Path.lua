Path = {}
Path.__index = Path

function Path:new()
  local xStart = -RADIUS_PATH
  local xFinish = WINDOW_WIDTH + RADIUS_PATH
  local xIncrement = (xFinish - xStart) / POINTS_PATH
  local segments = {}
  local previousY = math.random(HEIGHT_MIN, HEIGHT_MAX)
  for i = 1, POINTS_PATH do
    local x1 = xStart + xIncrement * (i - 1)
    local x2 = xStart + xIncrement * i
    local y1 = previousY
    local y2 = math.random(HEIGHT_MIN, HEIGHT_MAX)
    previousY = y2
    local start = LVector:new(x1, y1)
    local finish = LVector:new(x2, y2)
    table.insert(
      segments,
      {
        ["start"] = start,
        ["finish"] = finish
      }
    )
  end

  local this = {
    ["r"] = RADIUS_PATH,
    ["lineWidth"] = LINE_WIDTH_PATH,
    ["segments"] = segments
  }

  setmetatable(this, self)
  return this
end

function Path:render()
  for i, segment in ipairs(self.segments) do
    love.graphics.setColor(0.11, 0.11, 0.11, 0.1)
    love.graphics.setLineWidth(self.r * 2)
    love.graphics.line(segment.start.x, segment.start.y, segment.finish.x, segment.finish.y)

    love.graphics.setColor(0.11, 0.11, 0.11, 1)
    love.graphics.setLineWidth(self.lineWidth)
    love.graphics.line(segment.start.x, segment.start.y, segment.finish.x, segment.finish.y)
  end
end
