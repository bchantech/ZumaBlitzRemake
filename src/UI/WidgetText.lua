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
	
	-- number easing 
	self.number_time = nil
	self.number_time_target = nil
	self.number_orig = nil
	self.number_target = nil
	self.number_method = nil

end

function UIWidgetText:setNumber(x, t, m)
	if t and type(x) == "number" and type(self.text) == "number" then
		self.number_orig = self.text
		self.number_target = x
		self.number_time = 0
		self.number_time_target = t
		if m then self.number_method = m end
	else
		self.text = x
	end
end

function UIWidgetText:updateNumber(dt)
	if self.number_time then
		self.number_time = self.number_time + dt
		local t = math.min(self.number_time/self.number_time_target,1)
		t = self.parent:easing(t, self.number_method)
		self.text = math.floor(self.number_orig + ( (self.number_target - self.number_orig) * t))
		if self.number_time > self.number_time_target then self.number_time = nil; end
	end

end

function UIWidgetText:draw(variables)
	local textTmp = self.text

	if type(textTmp) == "number" then 
		textTmp = _NumStr(self.text) 
	end

	local scale = self.parent.scale_size or Vec2(1)

	textTmp = string.gsub(textTmp, "$expr{.-}", function(s) return _NumStr(_Vars:evaluateExpression(s)) end)
	self.font:draw(textTmp, self.parent:getPos(), self.align, nil, self.parent:getAlpha(), scale, self.parent.blendMode)
end

function UIWidgetText:getSize()
	local textTmp = string.gsub(self.textTmp, "$expr{.-}", function(s) return _NumStr(_Vars:evaluateExpression(s)) end)
	return self.font:getTextSize(textTmp)
end

return UIWidgetText
