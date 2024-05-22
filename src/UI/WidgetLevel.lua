local class = require "com.class"

---@class UIWidgetLevel
---@overload fun(parent, path):UIWidgetLevel
local UIWidgetLevel = class:derive("UIWidgetLevel")

local Map = require("src.Map")

function UIWidgetLevel:new(parent, path)
	self.type = "level"
	
	self.parent = parent
	local data = _LoadJson(_ParsePath(path))
	self.map = Map(self, "maps/" .. data.map, data.pathsBehavior, true)
end



function UIWidgetLevel:update(dt)
	if not self.parent.visible then return end
	self.map:update(dt)
end

function UIWidgetLevel:draw(variables)
	self.map:draw()
	self.map:drawSpheres()
end

return UIWidgetLevel