function init(v)
  if v then object.setInteractive(true) end
  if storage.active == nil then storage.active = true end
  self.jumpt = 0
end

function onInteract(args)
  storage.active = not storage.active
end

function main()
  if self.jumpt > 0 then self.jumpt = self.jumpt - 1 end
  if storage.active then
    local eids = world.monsterQuery(object.position(), object.configParameter("objectWidth"), { inSightOf = true })
    for i,id in ipairs(eids) do
      local v = world.callScriptedEntity(id, "entity.velocity")
      v[2] = -v[2] * 1.25
      world.callScriptedEntity(id, "entity.setVelocity", v)
      self.jumpt = 10
    end
  end
  local state = object.animationState("jumpState")
  if state == "idle" and self.jumpt > 0 then
    object.setAnimationState("jumpState", "jump")
    object.playImmediateSound(object.configParameter("jumpSound"))
  elseif state == "jump" and self.jumpt < 1 then object.setAnimationState("jumpState", "idle") end
end