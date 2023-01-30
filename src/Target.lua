local class = require "com/class"

---@class Target
---@overload fun(spritePath, pos, isFreeSpin):Target
local Target = class:derive("Target")

local Vec2 = require("src/Essentials/Vector2")



---Initialize a new Target.
---@param spritePath string
---@param pos Vector2
---@param isFreeSpin boolean
function Target:new(spritePath, pos, isFreeSpin)
    self.sprite = _Game.resourceManager:getSprite(spritePath)
    self.pos = pos
    self.frame = Vec2(1)
    self.isFreeSpin = isFreeSpin -- not used atm
    self.delQueue = false

    self.duration = 10
end



---Updates this target.
---@param dt number Delta time in seconds.
function Target:update(dt)
    if _Game:levelExists() and _Game.session.level.target then
        self.duration = self.duration - dt
        if self.duration < 0 then
            self:destroy()
            _Game:playSound("sound_events/target_despawn.json")
        end
    end
end



---Draws this Target.
function Target:draw()
    -- line that draws the glow goes here, probably a particle
    self.sprite:draw(self.pos, Vec2(0.5))
end



function Target:onShot()
    self:destroy()
    _Game:playSound("sound_events/target_hit.json")
    _Game.session.level:grantScore(_Game.session.level.targetHitScore)
    local shouldGiveOneSecond = _MathAreKeysInTable(_Game:getCurrentProfile():getEquippedFoodItemEffects(), "targetsGiveOneSecond")
	if shouldGiveOneSecond then
        _Game.session.level:applyEffect({type = "addTime", amount = 1})
    end
    _Game.session.level:spawnFloatingText(
        string.format("BONUS\n+%s", _NumStr(_Game.session.level.targetHitScore * _Game.session.level.multiplier)),
        self.pos,
        "fonts/score0.json"
    )

    -- Activate Hot Frog if we're using the Spirit Turtle
    if _Game:getCurrentProfile():getActiveMonument() == "spirit_turtle" then
        _Game.session.level:incrementBlitzMeter(1, true)
    end

    _Game.session.level.targets = _Game.session.level.targets + 1
end



function Target:destroy()
    if self.delQueue then
		return
	end
	self.delQueue = true
end



function Target:serialize()
    local t = {
        pos = self.pos,
        isFreeSpin = self.isFreeSpin,
        delQueue = self.delQueue,
        duration = self.duration
    }
    return t
end



function Target:deserialize(t)
    self.pos = t.pos
    self.isFreeSpin = t.isFreeSpin
    self.delQueue = t.delQueue
    self.duration = t.duration
end



return Target