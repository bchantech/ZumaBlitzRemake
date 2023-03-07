local class = require "com.class"

---@class Frogatar
---@overload fun(data):Frogatar
local Frogatar = class:derive("Frogatar")

--imports



function Frogatar:new(data)
    self.displayName = data.displayName
    self.shooterConfig = data.shooterConfig
end



function Frogatar:changeTo()
    if not _Game:levelExists() then
        return
    end
    _Game.session.level.shooter:changeTo(self.shooterConfig)
end



return Frogatar