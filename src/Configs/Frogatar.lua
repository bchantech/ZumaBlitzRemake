local class = require "com.class"

---@class Frogatar
---@overload fun(data):Frogatar
local Frogatar = class:derive("Frogatar")

--imports



function Frogatar:new(data)
    self.displayName = data.displayName
    self.isMonument = data.isMonument
    self.coinCosts = data.coinCosts
    self.shooterConfig = data.shooterConfig
    self.effects = data.effects or {}
    self.transformSound = data.transformSound
    self.transformText = data.transformText
end



function Frogatar:getEffects()
    return self.effects
end



---@param level Level
function Frogatar:changeTo(level)
    level.shooter:changeTo(self.shooterConfig)
end



return Frogatar