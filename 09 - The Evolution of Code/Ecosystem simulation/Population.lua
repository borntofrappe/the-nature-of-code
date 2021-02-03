Population = {}
Population.__index = Population

function Population:new()
  local bloops = {}
  for i = 1, BLOOP_INITIAL_POPULATION do
    local bloop = Bloop:new()
    table.insert(bloops, bloop)
  end

  local pellets = {}
  for i = 1, PELLET_POPULATION do
    local pellet = Pellet:new()
    table.insert(pellets, pellet)
  end

  local this = {
    ["bloops"] = bloops,
    ["pellets"] = pellets
  }

  setmetatable(this, self)
  return this
end

function Population:update(dt)
  for i = #self.bloops, 1, -1 do
    local bloop = self.bloops[i]
    bloop:update(dt)

    for j = #self.pellets, 1, -1 do
      if bloop:collides(self.pellets[j]) then
        bloop:increaseLifespan()
        table.remove(self.pellets, j)
        table.insert(self.pellets, Pellet:new())
      end
    end

    if math.random(BLOOP_ODDS) == 1 then
      local r = bloop.r
      r = r * (math.random() * 0.2 + 0.9)
      table.insert(self.bloops, Bloop:new(bloop.position.x, bloop.position.y, r))
    end

    if bloop.lifespan == 0 then
      table.remove(self.bloops, i)
    end
  end
end

function Population:render()
  for i, bloop in ipairs(self.bloops) do
    bloop:render()
  end

  for i, pellet in ipairs(self.pellets) do
    pellet:render()
  end
end
