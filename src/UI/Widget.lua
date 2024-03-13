local class = require "com.class"

---@class UIWidget
---@overload fun(name, data, parent):UIWidget
local UIWidget = class:derive("UIWidget")

local UIWidgetRectangle = require("src.UI.WidgetRectangle")
local UIWidgetSprite = require("src.UI.WidgetSprite")
local UIWidgetSpriteButton = require("src.UI.WidgetSpriteButton")
local UIWidgetSpriteButtonCheckbox = require("src.UI.WidgetSpriteButtonCheckbox")
local UIWidgetSpriteButtonSlider = require("src.UI.WidgetSpriteButtonSlider")
local UIWidgetSpriteProgress = require("src.UI.WidgetSpriteProgress")
local UIWidgetSpriteProgressBlitz = require("src.UI.WidgetSpriteProgressBlitz")
local UIWidgetText = require("src.UI.WidgetText")
local UIWidgetTextInput = require("src.UI.WidgetTextInput")
local UIWidgetParticle = require("src.UI.WidgetParticle")
local UIWidgetLevel = require("src.UI.WidgetLevel")

local Vec2 = require("src.Essentials.Vector2")



function UIWidget:new(name, data, parent)
	self.name = name

	-- positions, alpha etc. are:
	-- local in variables
	-- global in methods
	if type(data) == "string" then data = _LoadJson(_ParsePath(data)) end

	self.pos = _ParseVec2(data.pos or {x = 0, y = 0})
	self.mousePressLoc = {x = 0, y = 0}
	self.draggable = data.draggable or false
	self.angle = data.angle or 0
	self.align = data.align or Vec2()
	self.layer = data.layer
	self.alpha = data.alpha or 0
	self.scrollable = data.scrollable or false
	self.scroll_pos = 0
	self.scale_size = data.scale or Vec2(1)
	self.mousedownlock = false

	self.animations = {in_ = nil, out = nil}
	if data.animations then
		self.animations.in_ = data.animations.in_
		self.animations.out = data.animations.out
	end
	self.sounds = {in_ = nil, out = nil}
	if data.sounds then
		if data.sounds.in_ then self.sounds.in_ = _Game.resourceManager:getSoundEvent(data.sounds.in_) end
		if data.sounds.out then self.sounds.out = _Game.resourceManager:getSoundEvent(data.sounds.out) end
	end

	self.widget = nil
	if data.type == "rectangle" then
		self.widget = UIWidgetRectangle(self, data.size, data.color)
	elseif data.type == "sprite" then
		self.widget = UIWidgetSprite(self, data.sprite)
	elseif data.type == "spriteButton" then
		self.widget = UIWidgetSpriteButton(self, data.sprite)
	elseif data.type == "spriteButtonCheckbox" then
		self.widget = UIWidgetSpriteButtonCheckbox(self, data.sprite)
	elseif data.type == "spriteButtonSlider" then
		self.widget = UIWidgetSpriteButtonSlider(self, data.sprite, data.bounds)
	elseif data.type == "spriteProgress" then
		self.widget = UIWidgetSpriteProgress(self, data.sprite, data.value, data.smooth, data.progressBarType)
	elseif data.type == "spriteProgressBlitz" then
		self.widget = UIWidgetSpriteProgressBlitz(self, data.sprite, data.value, data.smooth)
	elseif data.type == "text" then
		self.widget = UIWidgetText(self, data.text, data.font, data.align)
	elseif data.type == "textInput" then
		self.widget = UIWidgetTextInput(self, data.font, data.align, data.cursorSprite, data.maxLength)
	elseif data.type == "particle" then
		self.widget = UIWidgetParticle(self, data.path)
	elseif data.type == "level" then
		self.widget = UIWidgetLevel(self, data.path)
	else
		data.type = "none"
	end

	self.parent = parent
	self.children = {}
	if data.children then
		for childN, child in pairs(data.children) do
			self.children[childN] = UIWidget(childN, child, self)
		end
	end
	self.blendMode = data.blendMode

	self.inheritShow = data.inheritShow or false
	self.inheritHide = data.inheritHide or false
	self.inheritPos = data.inheritPos
	if self.inheritPos == nil then self.inheritPos = true end
	self.visible = false
	self.neverDisabled = data.neverDisabled
	self.animationTime = nil
	self.hideDelay = data.hideDelay
	self.showDelay = data.showDelay
	self.time = data.showDelay

	self.actions = {}
	self.active = false
	self.hotkey = data.hotkey

	self.callbacks = data.callbacks

	-- custom origin
	self.origin = _ParseVec2(data.origin or {x = 0, y = 0})

	-- custom move animation
	self.move_time = nil
	self.move_time_target = nil
	self.move_method = nil
	self.move_orig = {x = 0, y = 0}
	self.move_target = {x = 0, y = 0}

	-- custom scale animation
	self.scale_time = nil
	self.scale_time_target = nil
	self.scale_method = nil
	self.scale_orig = {x = 0, y = 0}
	self.scale_target = {x = 0, y = 0}
	
	-- custom rotation animation
	self.rotate_time = nil
	self.rotate_time_target = nil
	self.rotate_method = nil
	self.rotate_orig = 0
	self.rotate_target = 0
	
	-- custom opacity animation
	self.opacity_time = nil
	self.opacity_time_target = nil
	self.opacity_method = nil
	self.opacity_orig = 0
	self.opacity_target = 0
	
	-- custom clipping (beta)
	self.clip = data.clip

	-- custom delay
	self.delay = data.showDelay or 0

	-- init animation alpha/position
	if self.animations.in_ then
		if self.animations.in_.type == "fade" then
			self.alpha = self.animations.in_.startValue
		elseif self.animations.in_.type == "move" then
			self.pos = _ParseVec2(self.animations.in_.startPos)
		end
	end
end

function UIWidget:update(dt)
	if self.animationTime then
		self.animationTime = self.animationTime + dt

		local animation = self.visible and self.animations.in_ or self.animations.out
		local t = math.min(self.animationTime / animation.time, 1)
		if animation.type == "fade" then
			self.alpha = animation.startValue * (1 - t) + animation.endValue * t
		elseif animation.type == "move" then
			self.pos = _ParseVec2(animation.startPos) * (1 - t) + _ParseVec2(animation.endPos) * t
		end

		if self.animationTime >= animation.time then
			self.animationTime = nil
			if self.visible then
				self:executeAction("showEnd")
				if self.widget and self.widget.type == "particle" then self.widget:spawn() end
			else
				self:executeAction("hideEnd")
			end
			--if not self.visible then self.alpha = 0 end
			-- instead, you need to clean up the black background manually!
		end
	end
	if self.time and (not self.parent or self.parent:isVisible()) then
		self.time = self.time - dt
		if self.time <= 0 then
			self.time = nil
			if self.visible then self:hide() else self:show() end
		end
	end
	-- schedule if was deliberately cancelled from the timer - avoid softlock
	if not self.time and self.parent and not self.parent:isVisible() then
		if self.visible then self.time = self.hideDelay else self.time = self.showDelay end
	end
	if self.widget and self.widget.update then self.widget:update(dt) end

	-- custom move animation
	if self.move_time and self.delay <= 0 then
		self.move_time = self.move_time + dt
		-- the target time is normalized to 1, and position slider is target-origin
		local t = math.min(self.move_time/self.move_time_target,1)
		-- additional transform for display purposes
		local t_t = self:easing(t, self.move_method)
				
		-- set new position
		self.pos.x = self.move_orig.x + ( (self.move_target.x - self.move_orig.x) * t_t)
		self.pos.y = self.move_orig.y + ( (self.move_target.y - self.move_orig.y) * t_t)

		--print(self.move_orig.x .. "," .. self.move_orig.y)
		--print(t)

		if self.move_time > self.move_time_target then self.move_time = nil; self:executeAction("moveEnd");  end
	end
	
	-- custom scale animation
	if self.scale_time then
		self.scale_time = self.scale_time + dt
		local t = math.min(self.scale_time/self.scale_time_target,1)

		-- additional transform for display purposes
		local t_t = self:easing(t, self.scale_method)

		-- set new size
		self.scale_size.x = self.scale_orig.x + ( (self.scale_target.x - self.scale_orig.x) * t_t)
		self.scale_size.y = self.scale_orig.y + ( (self.scale_target.y - self.scale_orig.y) * t_t)

		if self.scale_time > self.scale_time_target then self.scale_time = nil; self:executeAction("scaleEnd"); end
	end
	
	-- custom rotate animation
	if self.rotate_time then
		self.rotate_time = self.rotate_time + dt
		local t = math.min(self.rotate_time/self.rotate_time_target,1)

		-- additional transform for display purposes
		local t_t = self:easing(t, self.rotate_method)

		-- set new rotate
		self.angle = self.rotate_orig + ( (self.rotate_target - self.rotate_orig) * t_t)

		if self.rotate_time > self.rotate_time_target then self.rotate_time = nil; self:executeAction("rotateEnd");  end
	end

	-- custom opacity animation
    -- NOTE: a value of 0 does not 'hide' the element or trigger its callback
	if self.opacity_time then
		self.opacity_time = self.opacity_time + dt
		local t = math.min(self.opacity_time/self.opacity_time_target,1)

		-- additional transform for display purposes
		local t_t = self:easing(t, self.opacity_method)

		-- set new opacity
		self.alpha = self.opacity_orig + ( (self.opacity_target - self.opacity_orig) * t_t)

		if self.opacity_time > self.opacity_time_target then self.opacity_time = nil; self:executeAction("opacityEnd");  end
	end
	
	-- update the number individually
	if self.widget and self.widget.type == "text" then self.widget:updateNumber(dt) end

	-- update delay
	if self.delay > 0 then self.delay = self.delay - dt; end

	for childN, child in pairs(self.children) do
		child:update(dt)
	end
end

function UIWidget:show()
	if self.time then return end
	if not self.visible then
		--print("[" .. tostring(totalTime) .. "] " .. self:getFullName() .. " shown")
		self.visible = true
		if self.animations.in_ then
			self.animationTime = 0
			if self.animations.in_.type == "fade" then -- prevent background flickering on the first frame
				self.alpha = self.animations.in_.startValue
			end
		else
			self.animationTime = nil -- sets to 0 if animation exists, nil otherwise
			self.alpha = 1
			if self.widget and self.widget.type == "particle" then self.widget:spawn() end
		end
		if self.sounds.in_ then self.sounds.in_:play() end
	end
	self.time = self.hideDelay

	for childN, child in pairs(self.children) do
		if child.inheritShow then
			child:show()
		end
	end
end

function UIWidget:hide()
	if not self.showPermanently then
		if self.visible then
			--print("[" .. tostring(totalTime) .. "] " .. self:getFullName() .. " hidden")
			self.visible = false
			if self.animations.out then
				self.animationTime = 0
			else
				self.animationTime = nil -- sets to 0 if animation exists, nil otherwise
				if self.widget and self.widget.type == "particle" then self.widget:despawn() end
			end
			if self.sounds.out then self.sounds.out:play() end
			self.time = self.showDelay
		else
			self.time = nil
		end
	end

	for childN, child in pairs(self.children) do
		if child.inheritHide then
			child:hide()
		end
	end
end

function UIWidget:clean()
	if not self.showPermanently then self.alpha = 0 end
	for childN, child in pairs(self.children) do
		child:clean()
	end
end

-- If the item has a click action execute the widget's click action
-- Otherwise record x/y coord of click and start drag if the item is draggable and not over a button
function UIWidget:click(x,y,button)
	if self.active and self.widget and self.widget.click then self.widget:click(x,y,button)
	elseif self.active and self.widget and self.draggable and button == 1 and not self:isButtonHovered() and not self.mousedownlock then 
		self.mousePressLoc.x = x - self.pos.x
		self.mousePressLoc.y = y - self.pos.y
		self.mousedownlock = true
	end

	for childN, child in pairs(self.children) do
		child:click(x,y,button)
	end
end

function UIWidget:moveWindow(x,y)
	if self.active and self.widget and self.draggable and self.mousedownlock then
		self.pos.x = x - self.mousePressLoc.x
		self.pos.y = y - self.mousePressLoc.y
	end

	for childN, child in pairs(self.children) do
		child:moveWindow(x,y)
	end
end

function UIWidget:unclick()
	self.mousedownlock = false
	if self.widget and self.widget.unclick then self.widget:unclick() end

	for childN, child in pairs(self.children) do
		child:unclick()
	end
end

function UIWidget:wheelmoved(y)
	if self.active and self.widget and self.scrollable and self.widget.wheelmoved then  
		self.widget:wheelmoved(y)
	end

	for childN, child in pairs(self.children) do
		child:wheelmoved(y)
	end
end

function UIWidget:keypressed(key)
	if self.active and self.widget and self.widget.keypressed then self.widget:keypressed(key) end

	for childN, child in pairs(self.children) do
		child:keypressed(key)
	end
end

function UIWidget:textinput(t)
	if self.active and self.widget and self.widget.textinput then self.widget:textinput(t) end

	for childN, child in pairs(self.children) do
		child:textinput(t)
	end
end

function UIWidget:setActive(r)
	if not r then _Game.uiManager:resetActive() end

	self.active = true

	for childN, child in pairs(self.children) do
		child:setActive(true)
	end
end

function UIWidget:resetActive()
	self.active = false

	for childN, child in pairs(self.children) do
		child:resetActive()
	end
end

function UIWidget:buttonSetEnabled(enabled)
	if self.widget and self.widget.type == "spriteButton" then
		self.widget:setEnabled(enabled)
	end
end

function UIWidget:isButtonHovered()
	if self.active and self.widget then
		if self.widget.type == "spriteButton" and self.widget.hovered then
			return true
		elseif (self.widget.type == "spriteButtonCheckbox" or self.widget.type == "spriteButtonSlider") and self.widget.button.hovered then
			return true
		end
	end

	for childN, child in pairs(self.children) do
		if child:isButtonHovered() then
			return true
		end
	end
	return false
end



-- APPROACH 1: ORIGINAL
--[[
function UIWidget:generateDrawData()
	for childN, child in pairs(self.children) do
		child:generateDrawData()
	end
	if self.widget and self.widget.type == "text" then
		self.widget.textTmp = parseString(self.widget.text)
	end
end

function UIWidget:draw(layer)
	for childN, child in pairs(self.children) do
		child:draw(layer)
	end
	dbg.uiWidgetCount = dbg.uiWidgetCount + 1
	if self:getAlpha() == 0 then return end -- why drawing excessively?
	if self.widget and self:getLayer() == layer then self.widget:draw() end
end
]]--



-- APPROACH 2: OPTIMIZED

--[[
function UIWidget:generateDrawData()
	for childN, child in pairs(self.children) do
		child:generateDrawData()
	end
	if self.widget and self.widget.type == "text" then
		self.widget.textTmp = parseString(self.widget.text)
	end
end

function UIWidget:draw(layer)
	if self:getAlpha() == 0 then return end -- why drawing excessively?
	for childN, child in pairs(self.children) do
		child:draw(layer)
	end
	dbg.uiWidgetCount = dbg.uiWidgetCount + 1
	if self.widget and self:getLayer() == layer then self.widget:draw() end
end
]]--


-- APPROACH 3: MASSIVELY OPTIMIZED
function UIWidget:generateDrawData(layers, startN)
	for childN, child in pairs(self.children) do
		child:generateDrawData(layers, startN)
	end
	if self.widget then
		if self:getAlpha() > 0 then
			local names = self:getNames()
			names[1] = startN
			table.insert(layers[self:getLayer()], names)
		end
		if self.widget.type == "text" then
			if type(self.widget.text) == "number" then
				self.widget.textTmp = tostring(self.widget.text)
			elseif type(self.widget.text) == "string" then
				self.widget.textTmp = self.widget.text
			else 
				self.widget.textTmp = ""
			end

		end
	end
end

function UIWidget:draw()
	_Debug.uiWidgetCount = _Debug.uiWidgetCount + 1

	if self.clip then
		-- transform the rectangle into screen coordinates
		local pos = Vec2(self.clip.x, self.clip.y)
		pos = _PosOnScreen(pos)

		love.graphics.stencil(function()
			love.graphics.setColor(1, 1, 1)
			love.graphics.rectangle("fill", pos.x, pos.y, self.clip.w * _GetResolutionScale(), self.clip.h * _GetResolutionScale())
		end, "replace", 1)
		love.graphics.setStencilTest("equal", 1)
		self.widget:draw()
		love.graphics.setStencilTest()
	else
		self.widget:draw()
	end
end

function UIWidget:setNumber(x, t, m)
	self.widget:setNumber(x, t, m)
end




function UIWidget:getFullName()
	if self.parent then
		return self.parent:getFullName() .. "." .. self.name
	else
		return self.name
	end
end

function UIWidget:getNames(t)
	t = t or {}
	table.insert(t, 1, self.name)
	return self.parent and self.parent:getNames(t) or t
end

-- This function is phased out because it literally outputs itself but with less data.
-- function UIWidget:getTreeData()
	-- -- You may want to run this on the highest widget.
	-- local data = {name = self.name, visible = self.visible, time = self.time, children = {}}
	-- for childN, child in pairs(self.children) do
		-- table.insert(data.children, child:getTreeData())
	-- end
	-- return data
-- end

function UIWidget:getPos()
	if self.parent and self.inheritPos then
		local parentPos = self.parent:getPos()
		if self.parent.widget and self.parent.widget.type == "text" then
			parentPos = parentPos + self.parent.widget:getSize() * (Vec2(0.5) - self.parent.widget.align)
		end
		return parentPos + self.pos
	else
		return self.pos
	end
end

function UIWidget:setScrollPosRelative(y)
	if self.parent and self.inheritPos and self.scrollable then
		self.parent:setScrollPosRelative(y)
	else
		self.scroll_pos = self.scroll_pos + y
	end
end

function UIWidget:getAlpha()
	if self.parent then return self.parent:getAlpha() * self.alpha else return self.alpha end
end

function UIWidget:getLayer()
    if self.layer then
        return self.layer
    end
    if self.parent then
        return self.parent:getLayer()
    end
    return "MAIN"
end

-- function UIWidget:getVisible()
	-- local b = false
	-- for childN, child in pairs(self.children) do
		-- b = b or child:getVisible()
	-- end
	-- return b or (self.visible and not self.showPermanently)
-- end

function UIWidget:isVisible()
	if self.parent then return self.parent:isVisible() and self.visible else return self.visible end
end

function UIWidget:isActive()
	if not self.widget then return false end
	return self:isVisible() and self.active and self.widget.enableForced
end

function UIWidget:getAnimationFinished()
	local b = true
	for childN, child in pairs(self.children) do
		b = b and child:getAnimationFinished()
	end
	return b and not self.animationTime
end



function UIWidget:executeAction(actionType)
-- An action is a list of functions.
	-- Execute defined functions (JSON)
	if self.callbacks and self.callbacks[actionType] then
		_Game.uiManager:executeCallback(self.callbacks[actionType])
	end
	-- Execute scheduled functions (UI script)
	if self.actions[actionType] then
		for i, f in ipairs(self.actions[actionType]) do
			f(_Game.uiManager.scriptFunctions)
		end
		self.actions[actionType] = nil
	end
end

function UIWidget:scheduleFunction(actionType, f)
	if not self.actions[actionType] then self.actions[actionType] = {} end
	table.insert(self.actions[actionType], f)
end

-- UI FUNCTIONS --

-- function widget move transition
-- if there is no t, then it will instantly move without animation
-- if m is defined, allows you set the easing function to use.

function UIWidget:set_origin(x,y)
	self.origin.x = x
	self.origin.y = y
end

function UIWidget:set_position(x,y,t,m)
	if t then
		self.move_orig.x = self.pos.x
		self.move_orig.y = self.pos.y
		self.move_target.x = x - self.origin.x
		self.move_target.y = y - self.origin.y
		
		self.move_time = 0
		self.move_time_target = t
		if m then self.move_method = m end
	else
		self.pos.x = x - self.origin.x
		self.pos.y = y - self.origin.y
	end

end

function UIWidget:set_scale(x,y,t,m)
	if t then
		self.scale_orig.x = self.scale_size.x
		self.scale_orig.y = self.scale_size.y
		self.scale_target.x = x
		self.scale_target.y = y
		
		self.scale_time = 0
		self.scale_time_target = t
		if m then self.scale_method = m end
	else
		self.scale_size.x = x
		self.scale_size.y = y
	end
end

function UIWidget:set_rotation(x,t,m)
	if t then
		self.rotate_orig = self.angle
		self.rotate_target = x
		if m then self.rotate_method = m end
		
		self.rotate_time = 0
		self.rotate_time_target = t
	else
		self.rotate = x
	end
end

function UIWidget:set_alpha(x,t,m)

	if t then
		self.opacity_orig = self.alpha
		self.opacity_target = x
		if m then self.opacity_method = m end
		
		self.opacity_time = 0
		self.opacity_time_target = t
	else
		self.alpha = x
	end
end

function UIWidget:set_delay(t)
	self.delay = t
end


-- easing functions
-- https://easings.net/
-- supported - sine, cupic, circ, elastic, bounce, back,

function UIWidget:easing(t, type)

	if not type then type = "linear" end
	t = math.min(t,1)

	if type == "easeInBack" then
		local c1 = 1.70158
		local c3 = c1 + 1
		return c3 * t * t * t - c1 * t * t
	elseif type == "easeOutBack" then
		local c1 = 1.70158
		local c3 = c1 + 1
		return 1 + c3 * (t-1)^3 + c1 * (t-1)^2 
	elseif type == "easeInCubic" then
		return t^3
	elseif type == "easeOutCubic" then
		return 1 - (1 - t)^3
	elseif type == "easeInSine" then
		return 1 - math.cos((t * math.pi) / 2)
	elseif type == "easeOutSine" then
		return 1 - math.sin((t * math.pi) / 2)
	elseif type == "easeOutBounce" then
		print(t)
		local n1 = 7.5625
		local d1 = 2.75

		if t < 1 / d1 then return n1 * t * t
		elseif t < 2 / d1 then t = t - 1.5 / d1; return n1 * t * t + 0.75
		elseif t < 2.5 / d1 then t = t - 2.25 / d1; return n1 * t * t + 0.9375
		else t = t - 2.625 / d1; return n1 * t * t + 0.984375 end

	else
		-- defaults to linear
		return t
	end

end



return UIWidget
