local class = require "com.class"

---@class SpiritMonument
---@overload fun(data):SpiritMonument
local SpiritMonument = class:derive("SpiritMonument")

-- Place your imports here



function SpiritMonument:new(data)
    self.displayName = data.displayName
    self.shooterConfig = data.shooterConfig
    self.effects = data.effects or {}
    self.spiritBlastColor = data.spiritBlastColor
end



function SpiritMonument:changeTo()
    if not _Game:levelExists() then
        return
    end
    _Game.session.level.shooter:changeTo(self.shooterConfig)
end



return SpiritMonument