local class = require "com.class"

---@class SoundInstance
---@overload fun(path, instance):SoundInstance
local SoundInstance = class:derive("SoundInstance")

local Vec2 = require("src.Essentials.Vector2")



---Constructs a new Sound Instance.
---@param path string A path to the sound file.
---@param instance love.sound? A sound instance, if preloaded.
function SoundInstance:new(path, instance)
  self.path = path

  if instance then
    self.sound = instance
  else
    self.sound = _LoadSound(path, "static")
    if not self.sound then
      error("Failed to load sound: " .. path)
    end
  end

  self.volume = 1
  self.pos = _NATIVE_RESOLUTION / 2

  self.stereoErrorReported = false
end

function SoundInstance:update(dt)
	self.sound:setVolume(_Game.runtimeManager.options:getEffectiveSoundVolume() * self.volume)
end

function SoundInstance:play()
	self.sound:play()
end

function SoundInstance:pause()
  self.sound:pause()
end

function SoundInstance:stop()
	self.sound:stop()
end

function SoundInstance:setVolume(volume)
	self.volume = volume
end

function SoundInstance:setPitch(pitch)
  self.sound:setPitch(pitch)
end

function SoundInstance:setPos(pos)
  -- pos may be nilled by SoundEvent when flat flag is set
  if not pos then
    return
  end

  if self.sound:getChannelCount() == 1 then
    if _EngineSettings:get3DSound() and pos then
      self.pos = pos
      local p = pos - _NATIVE_RESOLUTION / 2
      self.sound:setPosition(p.x, p.y, _NATIVE_RESOLUTION.x * 2.5)
      self.sound:setAttenuationDistances(0, _NATIVE_RESOLUTION.x)
    else
      self.pos = Vec2()
      self.sound:setPosition(0, 0, 0)
    end
  else
    if not self.stereoErrorReported then
      _Log:printt("SoundEvent", string.format("The sound event \"%s\" is a stereo instance and must have it's \"flat\" property set to true.", self.path))
      self.stereoErrorReported = true
    end
  end
end

function SoundInstance:setLoop(loop)
  self.sound:setLooping(loop)
end

function SoundInstance:isPlaying()
  return self.sound:isPlaying()
end

return SoundInstance
