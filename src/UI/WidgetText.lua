local class = require "com.class"

---@class UIWidgetText
---@overload fun(parent, text, font, align):UIWidgetText
local UIWidgetText = class:derive("UIWidgetText")

local Vec2 = require("src.Essentials.Vector2")



function UIWidgetText:new(parent, text, font, align)
	self.type = "text"

	self.parent = parent

	self.text = text or " "
	self.textTmp = ""
	self.font = _Game.resourceManager:getFont(font)
	self.align = align and _ParseVec2(align) or Vec2(0.5, 0)
end



function UIWidgetText:draw(variables)
	
	local textTmp = string.gsub(self.textTmp, "$expr{.-}", function(s) return _NumStr(_Vars:evaluateExpression(s)) end)
	self.font:draw(textTmp, self.parent:getPos(), self.align, nil, self.parent:getAlpha(), nil, self.parent.blendMode)
end

function UIWidgetText:getSize()
	local textTmp = string.gsub(self.textTmp, "$expr{.-}", function(s) return _NumStr(_Vars:evaluateExpression(s)) end)
	return self.font:getTextSize(textTmp)
end

return UIWidgetText
