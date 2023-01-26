-- FORK-SPECIFIC-CODE: This is a special version of Progress Bar which is circular to mimic the Blitz's Hot Frog meter.
-- The smoothness also works differently here and that's actually something that could be backported soon.

local class = require "com/class"

---@class UIWidgetSpriteProgressBlitz
---@overload fun(parent, sprite, value, smooth):UIWidgetSpriteProgressBlitz
local UIWidgetSpriteProgressBlitz = class:derive("UIWidgetSpriteProgressBlitz")

local Vec2 = require("src/Essentials/Vector2")



function UIWidgetSpriteProgressBlitz:new(parent, sprite, value, smooth)
	self.type = "spriteProgressBlitz"

	self.parent = parent

	self.sprite = _Game.resourceManager:getSprite(sprite)
	self.size = self.sprite.img.size
	self.value = 0
	self.valueData = value
	self.smooth = smooth
end



function UIWidgetSpriteProgressBlitz:update(dt)
	local value = _ParseNumber(self.valueData)
	if self.smooth then
		if self.value < value then
			self.value = math.min(self.value + 0.15 * dt, value)
		elseif self.value > value then
			self.value = math.max(self.value - 2 * dt, value)
		end
	else
		self.value = value
	end
end

function UIWidgetSpriteProgressBlitz:draw(variables)
	local p1 = _PosOnScreen(self.parent:getPos())
	local p2 = _PosOnScreen(self.parent:getPos() + self.size)

	-- mark all pixels within the polygon with value of 1
	love.graphics.stencil(function()
		love.graphics.setColor(1, 1, 1)
		love.graphics.arc("fill", "pie", (p1.x + p2.x) / 2, p2.y, (p2.x - p1.x) / 2, -math.pi, -math.pi + (math.pi * self.value), 50)
	end, "replace", 1)
	-- mark only these pixels as the pixels which can be affected
	love.graphics.setStencilTest("equal", 1)
	-- draw the circle
	self.sprite:draw(self.parent:getPos(), nil, nil, nil, nil, nil, self.parent:getAlpha(), nil, self.parent.blendMode)
	-- reset the mask
	love.graphics.setStencilTest()
end

return UIWidgetSpriteProgressBlitz
