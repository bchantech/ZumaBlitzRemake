local class = require "com/class"

---@class Target
---@overload fun(params):Target
local Target = class:derive("Target")

local Vec2 = require("src/Essentials/Vector2")



---Initialize a new Target.
---@param spritePath string
---@param pos any
---@param isFreeSpin any
function Target:new(spritePath, pos, isFreeSpin)
    self.sprite = _Game.resourceManager:getSprite(spritePath)
    self.pos = pos
    self.isFreeSpin = isFreeSpin

    self.duration = 10 -- temporary value?
end



---Draws this Target.
function Target:draw()
    
end



return Target