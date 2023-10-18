local class = require "com.class"

---@class Image
---@overload fun(path):Image
local Image = class:derive("Image")

local Vec2 = require("src.Essentials.Vector2")



function Image:new(path)
	if type(path) == "string" then
		self.img = _LoadImage(path)
	else
		-- if path is an object, we assume path is a type Sprite.
		self.img = _LoadImageRaw(path)
	end

	if not self.img then error("Failed to load image: " .. path) end
	self.size = Vec2(self.img:getDimensions())
end

function Image:draw(...)
	love.graphics.draw(self.img, ...)
end

return Image
