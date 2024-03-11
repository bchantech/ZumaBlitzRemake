local class = require "com.class"
local Vec2 = require("src.Essentials.Vector2")

---@class UIWidgetSprite
---@overload fun(parent, sprite):UIWidgetSprite
local UIWidgetSprite = class:derive("UIWidgetSprite")



function UIWidgetSprite:new(parent, sprite)
	self.type = "sprite"

	self.parent = parent
	self.scale = Vec2(1)
	self.sprite = _Game.resourceManager:getSprite(sprite)
end



function UIWidgetSprite:draw()
	self.scale_render = self.parent.scale_size or Vec2(1)
	
	-- render the position so that transformation is origin center
	self.position_render = Vec2( -(self.sprite.frameSize.x/2 * (self.parent.scale_size.x - 1) ), -(self.sprite.frameSize.y/2 * (self.parent.scale_size.y - 1)) )

	self.sprite:draw(self.parent:getPos() + self.position_render + self.parent.origin - self.parent.origin:rotate(self.parent.angle), self.parent.align / self.sprite.size, nil, nil, self.parent.angle, nil, self.parent:getAlpha(), self.scale_render, self.parent.blendMode)
	
end


function UIWidgetSprite:wheelmoved(y)
	self.parent:setScrollPosRelative(y)
end

return UIWidgetSprite

