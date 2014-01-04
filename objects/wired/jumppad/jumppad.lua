function init(v)
  if storage.active == nil then storage.active = false end
  entity.setInteractive(true)
  self.jumpt = 0
end

function onInteract(args)
  storage.active = not storage.active
end

function main()
  if self.jumpt > 0 then self.jumpt = self.jumpt - 1
  else--if storage.active then
    local eids = world.entityQuery(entity.position(), entity.configParameter("objectWidth"), { inSightOf = true, notAnObject = true, order = "nearest" })
    if #eids > 0 then
      local e = entityProxy.create(eids[1])
      --local v = e.velocity()
      --v[2] = -v[2] * 1.25
      e.setVelocity({ 0, -20 })
      self.jumpt = 10
    end
  end
  local state = entity.animationState("jumpState")
  if state == "idle" and self.jumpt > 0 then
    entity.setAnimationState("jumpState", "jump")
    entity.playImmediateSound(entity.configParameter("jumpSound"))
  elseif state == "jump" and self.jumpt < 1 then entity.setAnimationState("jumpState", "idle") end
end