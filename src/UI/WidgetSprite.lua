local class = require "com.class"
local Vec2 = require("src.Essentials.Vector2")

---@class UIWidgetSprite
---@overload fun(parent, sprite):UIWidgetSprite
local UIWidgetSprite = class:derive("UIWidgetSprite")



function UIWidgetSprite:new(parent, sprite)
	self.type = "sprite"

	self.hovered = false
	self.clicked = false
	self.parent = parent
	self.scale = Vec2(1)
	self.sprite = _Game.resourceManager:getSprite(sprite)
	self.debugColor = {0.0,1.0,0.0}

	self.currentFrame = 1
	self:updateAnimationConsts()

end

function UIWidgetSprite:update(dt)
	if self.sprite and type(self.sprite) == "table" then
		
	self.animationFrame = self.animationFrame + self.animationSpeed * dt
	if self.animationFrame >= self.animationFrameCount + 1 then
		if self.animationLoop then self.animationFrame = self.animationFrame % self.animationFrameCount end
	end
	self.currentFrame = math.min(math.floor(self.animationFrame), self.animationFrameCount)

	end
end

-- Create a separate instance of animation constants from sprite.
function UIWidgetSprite:updateAnimationConsts()
	if self.sprite and type(self.sprite) == "table" then
		self.animationSpeed = self.sprite.animationSpeed
		self.animationFrameCount = self.sprite.animationFrameCount
		self.animationLoop = self.sprite.animationLoop
		self.animationFrame = self.sprite.animationFrameRandom and math.random(1, self.animationFrameCount) or 1
	end
end

function UIWidgetSprite:click()
	if not self.parent:isVisible() or not self.hovered or self.clicked then return end
	self.clicked = true
end

function UIWidgetSprite:unclick()
	if not self.clicked then return end
	if self.hovered then
		self.parent:executeAction("buttonClick")
	end
	self.clicked = false
end

function UIWidgetSprite:draw()
	-- if self.sprite is a string, reload the sprite.
	if type(self.sprite) == "string" then
		local new_sprite = self.sprite
		self.sprite = _Game.resourceManager:getSprite(new_sprite)
		self:updateAnimationConsts()
	end

	-- only draw the sprite if the resource is valid
	if self.sprite and type(self.sprite) == "table" then
		self.scale_render = self.parent.scale_size or Vec2(1)
		
		-- render the position so that transformation is origin center
		self.position_render = Vec2( -(self.sprite.frameSize.x/2 * (self.parent.scale_size.x - 1) ), -(self.sprite.frameSize.y/2 * (self.parent.scale_size.y - 1)) )

		self.sprite:draw(self.parent:getPos() + self.position_render + self.parent.origin - self.parent.origin:rotate(self.parent.angle), self.parent.align / self.sprite.size, nil, Vec2(self.currentFrame), self.parent.angle, nil, self.parent:getAlpha(), self.scale_render, self.parent.blendMode)

        -- Update the sprite's hovered status

		local pos = self.parent:getPos()
		local pos2 = pos + self.sprite.frameSize
		local hovered = self.parent.active and _MousePos.x >= pos.x and _MousePos.y >= pos.y and _MousePos.x < pos2.x and _MousePos.y < pos2.y
		if hovered ~= self.hovered then
			self.hovered = hovered
		end
	end
end


function UIWidgetSprite:wheelmoved(y)
	self.parent:setScrollPosRelative(y)
end

return UIWidgetSprite

