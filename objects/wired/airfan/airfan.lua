function init(v)
  if storage.active == nil then storage.active = false end
  entity.setInteractive(true)
  self.aet = { }
  self.affectWidth = entity.configParameter("affectWidth")
  self.fanPower = entity.configParameter("fanPower")
  self.timer = 0
end

function onInteract(args)
  storage.active = not storage.active
  if storage.active then entity.setAnimationState("fanState", "work")
  else
    entity.setAnimationState("fanState", "slow")
    self.timer = 20
  end
end

function filterEntities(eids)
  local valid = { "monster", "npc" }
  local ret = { }
  for i, id in ipairs(eids) do
    if self.aet[id] == nil then
      local et = world.entityType(id)
      for j, vt in ipairs(valid) do
        if et == vt then
          ret[#ret + 1] = id
          break
        end
      end
    end
  end
  return ret
end

function process(ox, oy, mult)
  local eids = world.entityQuery(entity.toAbsolutePosition({ ox, oy }), 2, { notAnObject = true, order = "nearest" })
  eids = filterEntities(eids)
  local f = entity.facingDirection
  for i,id in ipairs(eids) do
    local e = entityProxy.create(id)
    local v = e.velocity()
    v[1] = v[1] + self.fanPower * f * (self.affectWidth - x) / self.affectWidth
    e.setVelocity(v)
    self.aet[id] = true
  end
end

function main()
  if storage.active then
    for i,v in ipairs(self.aet) do self.aet[i] = nil end
    for x=1,self.affectWidth do
      for y=-1,1 do
        process(x, y)
      end
    end
  elseif self.timer > 0 then
    self.timer = self.timer - 1
    if self.timer == 0 then entity.setAnimationState("fanState", "idle") end
  end
end