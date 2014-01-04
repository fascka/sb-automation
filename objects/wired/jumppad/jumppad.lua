function init(v)
  self.jumpt = 0
end

function firstValidEntity(eids)
  local valid = { "monster", "npc" }
  for i, id in ipairs(eids) do
    local et = world.entityType(eids[i])
    for j, vt in ipairs(valid) do
      if et == vt then return id end
    end
  end
  return nil
end

function main()
  if self.jumpt > 0 then self.jumpt = self.jumpt - 1
  else
    local eids = world.entityQuery(entity.toAbsolutePosition({ 0, 2 }), entity.configParameter("scanRadius"), { notAnObject = true, order = "nearest" })
    local id = firstValidEntity(eids)
    if id ~= nil then
      local e = entityProxy.create(id)
      local v = e.velocity()
      v[2] = -v[2] + 50
      e.setVelocity(v)
      self.jumpt = 10
    end
  end
  local state = entity.animationState("jumpState")
  if state == "idle" and self.jumpt > 0 then
    entity.setAnimationState("jumpState", "jump")
    entity.playImmediateSound(entity.configParameter("jumpSound"))
  elseif state == "jump" and self.jumpt < 1 then entity.setAnimationState("jumpState", "idle") end
end