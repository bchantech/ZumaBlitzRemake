local class = require "com.class"

---@class SoundEvent
---@overload fun():SoundEvent
local SoundEvent = class:derive("SoundEvent")



function SoundEvent:new(path)
	self.path = path
  local data = _LoadJson(path)

  self.sound = nil
  self.sounds = {}
  self.random = data.random
  if data.random and data.paths then
    for _,v in pairs(data.paths) do
      table.insert(self.sounds, _Game.resourceManager:getSound(v))
    end
  elseif data.path then
    self.sound = _Game.resourceManager:getSound(data.path)
  end
  self.volume = data.volume or 1
  self.pitch = data.volume or 1
  self.loop = data.loop or false
	self.flat = data.flat or false
end

function SoundEvent:play(pitch, pos)
  if self.random then
    self.sound = self.sounds[math.random(1, #self.sounds)]
  end
  if not self.sound then
    return self
  end
  pitch = pitch or 1
  local eventVolume = _ParseNumber(self.volume)
  local eventPitch = _ParseNumber(self.pitch)
  local eventPos = not self.flat and pos
  
  return self.sound:play(eventVolume, pitch * eventPitch, eventPos, self.loop)
end

function SoundEvent:stop()
  if not self.sound then
    return
  end
  self.sound:stop()
end

return SoundEvent
