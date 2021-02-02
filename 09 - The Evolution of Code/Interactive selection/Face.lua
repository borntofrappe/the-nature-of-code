Face = {}
Face.__index = Face

function Face:new(i, dna)
  local offset = {
    ["x"] = WINDOW_WIDTH / 2 - WINDOW_WIDTH / POPULATION_SIZE * (i - 1 - math.floor(POPULATION_SIZE / 2)) -
      ELEMENT_SIZE / 2,
    ["y"] = WINDOW_PADDING
  }
  local size = ELEMENT_SIZE

  local dna = dna or DNA:new(19)

  local this = {
    ["dna"] = dna,
    ["fitness"] = ELEMENT_FITNESS_MIN,
    ["offset"] = offset,
    ["size"] = size,
    ["face"] = {
      ["size"] = map(dna.genes[1], 0, 1, FACE_SIZE_MIN, FACE_SIZE_MAX),
      ["color"] = {
        ["r"] = dna.genes[2],
        ["g"] = dna.genes[3],
        ["b"] = dna.genes[4]
      }
    },
    ["eyes"] = {
      ["leftSize"] = map(dna.genes[5], 0, 1, EYES_SIZE_MIN, EYES_SIZE_MAX),
      ["rightSize"] = map(dna.genes[6], 0, 1, EYES_SIZE_MIN, EYES_SIZE_MAX),
      ["color"] = {
        ["r"] = dna.genes[7],
        ["g"] = dna.genes[8],
        ["b"] = dna.genes[9]
      },
      ["gap"] = map(dna.genes[10], 0, 1, EYES_GAP_MIN, EYES_GAP_MAX),
      ["offset"] = {
        ["x"] = map(dna.genes[11], 0, 1, EYES_OFFSET_X_MIN, EYES_OFFSET_X_MAX),
        ["y"] = map(dna.genes[12], 0, 1, EYES_OFFSET_Y_MIN, EYES_OFFSET_Y_MAX)
      }
    },
    ["mouth"] = {
      ["width"] = map(dna.genes[13], 0, 1, MOUTH_WIDTH_MIN, MOUTH_WIDTH_MAX),
      ["height"] = map(dna.genes[14], 0, 1, MOUTH_HEIGHT_MIN, MOUTH_HEIGHT_MAX),
      ["color"] = {
        ["r"] = dna.genes[15],
        ["g"] = dna.genes[16],
        ["b"] = dna.genes[17]
      },
      ["offset"] = {
        ["x"] = map(dna.genes[18], 0, 1, -MOUTH_OFFSET_X_MIN, MOUTH_OFFSET_X_MAX),
        ["y"] = map(dna.genes[19], 0, 1, MOUTH_OFFSET_Y_MIN, MOUTH_OFFSET_Y_MAX)
      }
    }
  }

  setmetatable(this, self)
  return this
end

function Face:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.printf(string.format("%d", self.fitness), self.offset.x, self.offset.y + self.size, self.size, "center")

  love.graphics.setColor(self.face.color.r, self.face.color.g, self.face.color.b, 1)
  love.graphics.circle("fill", self.offset.x + self.size / 2, self.offset.y + self.size / 2, self.face.size)

  love.graphics.setColor(self.eyes.color.r, self.eyes.color.g, self.eyes.color.b, 1)
  love.graphics.circle(
    "fill",
    self.offset.x + self.size / 2 + self.eyes.offset.x - self.eyes.gap / 2,
    self.offset.y + self.size / 2 + self.eyes.offset.y,
    self.eyes.leftSize
  )
  love.graphics.circle(
    "fill",
    self.offset.x + self.size / 2 + self.eyes.offset.x + self.eyes.gap / 2,
    self.offset.y + self.size / 2 + self.eyes.offset.y,
    self.eyes.rightSize
  )

  love.graphics.setColor(self.mouth.color.r, self.mouth.color.g, self.mouth.color.b, 1)
  love.graphics.rectangle(
    "fill",
    self.offset.x + self.size / 2 + self.mouth.offset.x,
    self.offset.y + self.size / 2 + self.mouth.offset.y,
    self.mouth.width,
    self.mouth.height
  )
end

function Face:increaseFitness(dt)
  self.fitness = self.fitness + dt * WINDOW_UPADTE_SPEED
end
