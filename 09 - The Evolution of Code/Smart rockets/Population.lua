Population = {}
Population.__index = Population

function Population:new(size, mutationOdds, target, obstacles)
  local generation = 0
  local frame = 1
  local frames = FRAMES

  local population = {}
  for i = 1, size do
    local dna = DNA:new(frames)
    local rocket = Rocket:new(dna)
    table.insert(population, rocket)
  end

  local this = {
    ["size"] = size,
    ["mutationOdds"] = mutationOdds,
    ["population"] = population,
    ["target"] = target,
    ["obstacles"] = obstacles,
    ["frame"] = frame,
    ["frames"] = frames,
    ["generation"] = generation
  }

  setmetatable(this, self)
  return this
end

function Population:render()
  for i, rocket in ipairs(self.population) do
    rocket:render()
  end
end

function Population:update(dt)
  if self.frame <= self.frames then
    for i, rocket in ipairs(self.population) do
      if not rocket.hasReached and not rocket.hasCollided then
        rocket:update(dt, self.frame)

        if rocket:reaches(self.target) then
          rocket.hasReached = true
        else
          for j, obstacle in ipairs(self.obstacles) do
            if rocket:collides(obstacle) then
              rocket.hasCollided = true
              break
            end
          end
        end
      end
    end
    self.frame = self.frame + 1
  else
    self:generate()
    self.frame = 1
  end
end

function Population:select(maxFitness)
  while true do
    local index = math.random(#self.population)
    local rocket = self.population[index]
    local fitness = rocket:getFitness(self.target)
    fitness = fitness ^ 2
    local probability = math.random() * maxFitness
    if probability < fitness then
      return rocket
    end
  end
end

function Population:generate()
  local maxFitness = 0

  for i, rocket in ipairs(self.population) do
    local fitness = rocket:getFitness(self.target)
    if fitness > maxFitness then
      maxFitness = fitness
    end
  end

  local population = {}
  for i = 1, self.size do
    local parent1 = self:select(maxFitness)
    local parent2 = self:select(maxFitness)

    local dna = DNA:new(self.frames)
    dna:inherit(parent1, parent2, self.mutationOdds)
    local rocket = Rocket:new(dna)
    table.insert(population, rocket)
  end

  self.population = population
  self.generation = self.generation + 1
end
