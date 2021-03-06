Population = {}
Population.__index = Population

function Population:new(size, target, mutationOdds)
  local population = {}
  for i = 1, size do
    local vehicle = Vehicle:new()
    table.insert(population, vehicle)
  end

  local generation = 0

  local lifespan = LIFESPAN
  local timer = 0

  local bestVehicle = nil
  for i, vehicle in ipairs(population) do
    if not bestVehicle or vehicle:getFitness(target) > bestVehicle:getFitness(target) then
      bestVehicle = vehicle
    end
  end
  local field = bestVehicle.field

  local this = {
    ["size"] = size,
    ["population"] = population,
    ["target"] = target,
    ["mutationOdds"] = mutationOdds,
    ["generation"] = generation,
    ["lifespan"] = lifespan,
    ["timer"] = timer,
    ["field"] = field
  }

  setmetatable(this, self)
  return this
end

function Population:render()
  self.field:render()

  for i, vehicle in ipairs(self.population) do
    vehicle:render()
  end
end

function Population:update(dt)
  if self.timer <= self.lifespan then
    self.timer = self.timer + dt * UPDATE_SPEED

    for i, vehicle in ipairs(self.population) do
      vehicle:update(dt)
    end
  else
    self:generate()
    self:setBestField()
    self.timer = self.timer % self.lifespan
  end
end

function Population:select(maxFitness)
  while true do
    local index = math.random(#self.population)
    local vehicle = self.population[index]
    local fitness = vehicle:getFitness(self.target)
    fitness = fitness ^ 2
    local probability = math.random() * maxFitness
    if probability < fitness then
      return vehicle
    end
  end
end

function Population:generate()
  local maxFitness = 0

  for i, vehicle in ipairs(self.population) do
    local fitness = vehicle:getFitness(self.target)
    if fitness > maxFitness then
      maxFitness = fitness
    end
  end

  local population = {}
  for i = 1, self.size do
    local parent1 = self:select(maxFitness)
    local parent2 = self:select(maxFitness)

    local vehicle = Vehicle:new()
    vehicle:inherit(parent1, parent2, self.mutationOdds)
    table.insert(population, vehicle)
  end

  self.population = population
  self.generation = self.generation + 1
end

function Population:setBestField()
  local bestVehicle = nil

  for i, vehicle in ipairs(self.population) do
    if not bestVehicle or vehicle:getFitness(self.target) > bestVehicle:getFitness(self.target) then
      bestVehicle = vehicle
    end
  end

  self.field = bestVehicle.field
end
