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

  local this = {
    ["size"] = size,
    ["population"] = population,
    ["target"] = target,
    ["mutationOdds"] = mutationOdds,
    ["generation"] = generation,
    ["lifespan"] = lifespan,
    ["timer"] = timer
  }

  setmetatable(this, self)
  return this
end

function Population:update(dt)
  if self.timer <= self.lifespan then
    self.timer = self.timer + dt * UPDATE_SPEED

    for i, vehicle in ipairs(self.population) do
      vehicle:update(dt)
    end
  else
    self:generate()
    self.timer = self.timer % self.lifespan
  end
end

function Population:render()
  love.graphics.setColor(0.11, 0.11, 0.11, 1)
  love.graphics.print(string.format("%d", self.lifespan - self.timer), 8, 8)

  for i, vehicle in ipairs(self.population) do
    vehicle:render()
  end
end

function Population:generate()
  -- genetic algorithm
  local population = {}
  for i = 1, self.size do
    local vehicle = Vehicle:new()
    table.insert(population, vehicle)
  end

  self.population = population
end
