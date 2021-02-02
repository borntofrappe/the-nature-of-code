Population = {}
Population.__index = Population

function Population:new()
  local blobs = {}
  for i = 1, BLOB_INITIAL_POPULATION do
    local blob = Blob:new()
    table.insert(blobs, blob)
  end

  local pellets = {}
  for i = 1, PELLET_POPULATION do
    local pellet = Pellet:new()
    table.insert(pellets, pellet)
  end

  local this = {
    ["blobs"] = blobs,
    ["pellets"] = pellets
  }

  setmetatable(this, self)
  return this
end

function Population:update(dt)
  for i = #self.blobs, 1, -1 do
    local blob = self.blobs[i]
    blob:update(dt)

    for j = #self.pellets, 1, -1 do
      local pellet = self.pellets[j]
      if
        (pellet.x + pellet.size / 2 - blob.x) ^ 2 + (pellet.y + pellet.size / 2 - blob.y) ^ 2 <
          (pellet.size + blob.r) ^ 2
       then
        blob.lifespan = math.min(BLOB_LIFESPAN, blob.lifespan + BLOB_LIFESPAN_INCREMENT)
        table.remove(self.pellets, j)
        table.insert(self.pellets, Pellet:new())
      end
    end

    if math.random(BLOB_ODDS) == 1 then
      local r = blob.r
      r = r * (math.random() * 0.2 + 0.9)
      table.insert(self.blobs, Blob:new(blob.x, blob.y, r))
    end

    if blob.lifespan == 0 then
      table.remove(self.blobs, i)
    end
  end
end

function Population:render()
  for i, blob in ipairs(self.blobs) do
    blob:render()
  end

  for i, pellet in ipairs(self.pellets) do
    pellet:render()
  end
end
