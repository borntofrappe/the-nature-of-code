Population = {}
Population.__index = Population

function Population:new(size, mutationOdds)
  local population = {}
  for i = 1, size do
    table.insert(population, Face:new(i))
  end

  local generation = 0

  local this = {
    ["size"] = size,
    ["population"] = population,
    ["mutationOdds"] = mutationOdds,
    ["generation"] = generation
  }

  setmetatable(this, self)
  return this
end

function Population:update(dt)
  local x, y = love.mouse:getPosition()
  if x > 0 and x < WINDOW_WIDTH and y > 0 and y < WINDOW_HEIGHT then
    for i, face in ipairs(self.population) do
      if x > face.offset.x and x < face.offset.x + face.size and y > face.offset.y and y < face.offset.y + face.size then
        face:increaseFitness(dt)
        break
      end
    end
  end
end

function Population:render()
  for i, face in ipairs(self.population) do
    face:render()
  end
end

function Population:select(cumulativeFitness)
  while true do
    local index = math.random(#self.population)
    local face = self.population[index]
    local fitness = face.fitness
    local probability = math.random() * cumulativeFitness
    if probability < fitness then
      return face
    end
  end
end

function Population:generate()
  local cumulativeFitness = 0

  for i, face in ipairs(self.population) do
    cumulativeFitness = cumulativeFitness + face.fitness
  end

  local population = {}
  for i = 1, self.size do
    local parent1 = self:select(cumulativeFitness)
    local parent2 = self:select(cumulativeFitness)

    local dna = DNA:new(#parent1.dna.genes)
    dna:inherit(parent1, parent2, self.mutationOdds)

    local face = Face:new(i, dna)
    table.insert(population, face)
  end

  self.population = population
  self.generation = self.generation + 1
end
