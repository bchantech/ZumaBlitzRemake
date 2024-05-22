local class = require "com.class"

---@class UI2WidgetLevel
---@overload fun(parent, align, level):UI2WidgetLevel
local UI2WidgetLevel = class:derive("UI2WidgetLevel")

local Map = require("src.Map")



---Constructs a new Level Widget.
---@param node UI2Node The Node this Widget is bound to.
---@param level string The level JSON to use for the level.
function UI2WidgetLevel:new(node, align, level)
	self.type = "level"
	
    self.node = node
    self.align = align
	
	local data = _LoadJson(_ParsePath(path))
	self.map = Map(self, "maps/" .. data.map, data.pathsBehavior, true)
end



function UI2WidgetLevel:getSize()
	return _ParseVec2(_Game.configManager.config.nativeResolution) * self.node:getGlobalScale()
end

function UI2WidgetLevel:getPos()
	return self.node:getGlobalPos() - self:getSize() * self.align
end

function UI2WidgetLevel:update(dt)
	if not self.node:isVisible() then return end
	self.map:update(dt)
end

function UI2WidgetLevel:draw(variables)
	self.map:draw()
	self.map:drawSpheres()
end

return UI2WidgetLevel