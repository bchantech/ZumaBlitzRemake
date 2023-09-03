local class = require "com.class"

---Represents a Shooter which is controlled by the player. Has a current and a next sphere slot. Can have multi-spheres and speed shot.
---@class Shooter
---@overload fun():Shooter
local Shooter = class:derive("Shooter")

local Vec2 = require("src.Essentials.Vector2")
local Sprite = require("src.Essentials.Sprite")
local Color = require("src.Essentials.Color")

local SphereEntity = require("src.SphereEntity")
local ShotSphere = require("src.ShotSphere")



---Constructs a new Shooter.
---@param data? table Data for the shooter.
function Shooter:new(data)
    self.levelMovement = data and data.movement
    self:changeTo(data and data.name or "default")

    self.pos = self:getInitialPos()
    self.angle = self:getInitialAngle()

    self.color = 0
    self.nextColor = 0
    self.shotCooldown = nil
    self.shotCooldownFade = nil
    self.speedShotSpeed = 0
    self.speedShotTime = 0
    self.speedShotAnim = 0
    self.speedShotParticle = nil
    self.multiColorColor = nil
    self.multiColorCount = 0
    self.knockbackAngle = 0
    self.knockbackTime = 0
    self.swapped = false


    -- memorizing the pressed keys for keyboard control of the shooter
    self.moveKeys = {left = false, right = false}
    self.mousePos = _MousePos
    -- the speed of the shooter when controlled via keyboard
    self.moveKeySpeed = 500
    self.rotateKeySpeed = 4

    self.sphereEntity = nil
end



---Changes this Shooter's configuration to the given one.
---@param name string The new shooter config to be obeyed.
function Shooter:changeTo(name)
    self.config = _Game.configManager:getShooter(name)
    self.movement = self.levelMovement or self.config.movement

    self.sprite = self.config.sprite
    self.warmSprite = self.config.warmSprite
    self.hotSprite = self.config.hotSprite
    self.cannonSprite = self.config.cannonSprite

    self.spriteAsOverlay = self.config.spriteAsOverlay

    self.overlaySprite = self.config.overlaySprite
    self.warmOverlaySprite = self.config.warmOverlaySprite
    self.hotOverlaySprite = self.config.hotOverlaySprite
    self.cannonOverlaySprite = self.config.cannonOverlaySprite

    self.shadowSprite = self.config.shadowSprite
    self.speedShotSprite = self.config.speedShotBeam.sprite

    self.reticleSprite = self.config.reticle.sprite
    self.reticleNextSprite = self.config.reticle.nextBallSprite
    self.radiusReticleSprite = self.config.reticle.radiusSprite
end



---Updates the Shooter.
---@param dt number Delta time in seconds.
function Shooter:update(dt)
    -- movement
    if self.movement.type == "linear" then
        -- luxor shooter
        if _MousePos == self.mousePos then
            -- if the mouse position hasn't changed, then the keyboard can be freely used
            if self.moveKeys.left then
                self.pos.x = self.pos.x - self.moveKeySpeed * dt
            end
            if self.moveKeys.right then
                self.pos.x = self.pos.x + self.moveKeySpeed * dt
            end
        else
            -- else, the mouse takes advantage and overwrites the position
            self.pos.x = _MousePos.x
        end
        if self.movement.bidirectional == true then
            if self.mousePos.y > self.movement.y then
                self.angle = math.pi
            else
                self.angle = 0
            end
        end
        -- clamp to bounds defined in config
        self.pos.x = math.min(math.max(self.pos.x, self.movement.xMin), self.movement.xMax)
    elseif self.movement.type == "circular" then
        -- zuma shooter
        if _MousePos == self.mousePos then
            -- if the mouse position hasn't changed, then the keyboard can be freely used
            if self.moveKeys.left then
                self.angle = self.angle - self.rotateKeySpeed * dt
            end
            if self.moveKeys.right then
                self.angle = self.angle + self.rotateKeySpeed * dt
            end
        else
            -- else, the mouse takes advantage and overwrites the angle
            self.angle = (_MousePos - self.pos):angle() + math.pi / 2
        end
        -- make the angle be in the interval [-pi, pi)
        self.angle = (self.angle + math.pi) % (math.pi * 2) - math.pi
    end
    self.mousePos = _MousePos

    -- shot cooldown
    if self.shotCooldown and (not _Game.session.level:hasShotSpheres() or self.config.multishot) then
        self.shotCooldown = self.shotCooldown - dt
        if self.shotCooldown <= 0 then
            self.shotCooldown = nil
            self.shotCooldownFade = self.config.shotCooldownFade
        end
    end
    -- shot cooldown fade
    if self.shotCooldownFade then
        self.shotCooldownFade = self.shotCooldownFade - dt
        if self.shotCooldownFade <= 0 then
            self.shotCooldownFade = nil
        end
    end

    -- knockback
    if self.knockbackTime > 0 then
        self.knockbackTime = self.knockbackTime - dt

        if self.knockbackTime > 0 then
            if self.knockbackTime > 0.1 then
                self.pos = self.pos + Vec2(0, 1.15):rotate(self.knockbackAngle)
            else
                self.pos = self.pos + Vec2(0, -1.15):rotate(self.knockbackAngle)
            end
        else
            self.knockbackTime = 0
            self.pos = Vec2(self.movement.x or self.pos.x, self.movement.y or self.pos.y)
        end
    end

    -- filling, we are not removing nonexistent colors
    if self:isActive() then
        self:fill()
    end



    -- speed shot time counting
    if self.speedShotTime > 0 then
        self.speedShotTime = math.max(self.speedShotTime - dt, 0)
        self.speedShotAnim = math.min(self.speedShotAnim + dt / self.config.speedShotBeam.fadeTime, 1)
        if self.speedShotParticle then
            self.speedShotParticle.pos = self:getSpherePos()
        else
            self.speedShotParticle = _Game:spawnParticle(self.config.speedShotParticle, self:getSpherePos())
        end
    else
        self.speedShotAnim = math.max(self.speedShotAnim - dt / self.config.speedShotBeam.fadeTime, 0)
        if self.speedShotParticle then
            self.speedShotParticle:destroy()
            self.speedShotParticle = nil
        end
    end

    -- Update the sphere entity position.
    if self.sphereEntity then
        self.sphereEntity:setPos(self:getSpherePos())
    end

    -- Update swap reset if true
    self.swapped = false

end



---Sets the primary sphere color to a given sphere color ID.
---@param color integer The ID of a sphere color to be changed to. `0` will empty this slot.
function Shooter:setColor(color)
    self.color = color

    if color == 0 and self.sphereEntity then
        self.sphereEntity:destroy(false)
        self.sphereEntity = nil
    end
    if color ~= 0 then
        if self.sphereEntity then
            self.sphereEntity:setColor(color)
        else
            self.sphereEntity = SphereEntity(self:getSpherePos(), color)
        end
    end
end



---Sets the secondary sphere color to a given sphere color ID.
---@param color integer The ID of a sphere color to be changed to. `0` will empty this slot.
function Shooter:setNextColor(color)
    self.nextColor = color
end



---Empties this shooter. This includes removing all effects, such as speed shot or multi-color spheres.
function Shooter:empty()
    self:setColor(0)
    self:setNextColor(0)
    self.multiColorColor = nil
    self.multiColorCount = 0
    self.speedShotTime = 0
end



---Swaps this and next sphere colors with each other, if possible.
function Shooter:swapColors()
    -- we must be careful not to swap the spheres when they're absent
    if _Game.session.level.pause or self.color == 0 or self.nextColor == 0 or self.shotCooldownFade or not self:getSphereConfig().interchangeable then
        return
    end
    if self.swapped then
        return
    end

    local tmp = self.color
    self:setColor(self.nextColor)
    self:setNextColor(tmp)
    _Game:playSound(self.config.sounds.sphereSwap, 1, self.pos)
    _Game.session.level:recordSwap()
    self.swapped = true

end



---Generates a new sphere color ID for this shooter.
---@return integer
function Shooter:getNextColor()
    if self.multiColorCount == 0 then
        return _Game.session.level:getNewShooterColor()
    else
        self.multiColorCount = self.multiColorCount - 1
        return self.multiColorColor
    end
end



---Fills any empty spaces in the shooter.
function Shooter:fill()
    if self.nextColor == 0 or self.color == 0 then
        _Game:playSound(self.config.sounds.sphereFill, 1, self.pos)
    end
    if self.nextColor == 0 then
        self:setNextColor(self:getNextColor())
    end
    if self.color == 0 and self.nextColor ~= 0 then
        self:setColor(self.nextColor)
        self:setNextColor(self:getNextColor())
    end
end

---Forces shooter to be a certain angle.
---Used for replays and the like.
function Shooter:setAngle(angle)
    if (angle) then self.angle = angle end
end


---Returns whether the Shooter is active.
---When the shooter is deactivated, new balls won't be added and existing can't be shot or removed.
function Shooter:isActive()
    local level = _Game.session.level
    -- Eliminate all cases where we're not in the main level gameplay loop.
    if not level.started or level.lost or level:hasNoMoreSpheres() then
        return false
    end
    -- When there's already a shot sphere and the config does not permit more, disallow.
    if level:hasShotSpheres() and not self.config.multishot then
        return false
    end
    -- FORK-RELATED CHANGE: If the time's up, don't allow to shoot more spheres.
    if level:areAllObjectivesReached() then
        return false
    end
    -- Otherwise, allow.
    return true
end



---Launches the current sphere, if possible.
function Shooter:shoot()

    
    -- If within the intro sequence, will skip certain phases if possible.
    if _Game.session.level.started == false then
        _Game.session.level:changePhase()
        return
    end

    -- don't shoot if the shot is still on cooldown
    if self.shotCooldown then
        return
    end

    -- if nothing to shoot, it's pointless
    if _Game.session.level.pause or not self:isActive() or self.shotCooldownFade or self.color == 0 then
        return
    end
    -- add to stat if a hot frog shot is fired (-2)
    if self.color == -2 then
        _Game.session.level.hotFrogShotsFired = _Game.session.level.hotFrogShotsFired + 1
    end
    
    -- force angle to 1/10000 precision
    self.angle = math.floor(self.angle * 10000 +0.5)/10000 

    local sphereConfig = self:getSphereConfig()
    if sphereConfig.shootBehavior.type == "lightning" then
        -- lightning spheres are not shot, they're deployed instantly
        _Game:spawnParticle(sphereConfig.destroyParticle, self:getSpherePos())
        _Game.session:destroyVerticalColor(self.pos.x, sphereConfig.shootBehavior.range, self.color)
    else
        if sphereConfig.shootBehavior.type == "multishot" then
            local spread_max = 30.0
            local orbs_per_shot = sphereConfig.shootBehavior.amount
            local shot_angle_offset = -(spread_max / 2)
            local shot_angle = spread_max / orbs_per_shot
    
            for i = 1, orbs_per_shot do
                local fire_angle = self.angle + math.rad(shot_angle_offset + (shot_angle * i))
                _Game.session.level:spawnShotSphere(self, self:getSpherePos(), fire_angle, self:getSphereSize(), self.color, self:getShootingSpeed())
            end
        else
            _Game.session.level:spawnShotSphere(self, self:getSpherePos(), self.angle, self:getSphereSize(), self.color, self:getShootingSpeed())
        end
        
        self.sphereEntity = nil
        --self.active = false
        -- knockback
        if self.knockbackTime == 0 then
            self.knockbackTime = 0.2
            self.knockbackAngle = self.angle
        end
    end
    if sphereConfig.shootEffects then
        for i, effect in ipairs(sphereConfig.shootEffects) do
            _Game.session.level:applyEffect(effect)
        end
    end
    _Game:playSound(sphereConfig.shootSound, 1, self.pos)
    self.color = 0
    self.shotCooldown = self.config.shotCooldown
    _Game.session.level.spheresShot = _Game.session.level.spheresShot + 1
    _Game.session.level:recordFiredBall(self.angle)
end


---Deinitialization function.
function Shooter:destroy()
    if self.sphereEntity then
        self.sphereEntity:destroy(false)
    end
    if self.speedShotParticle then
        self.speedShotParticle:destroy()
    end
end



---Replaces the first non-empty slot of the shooter with a given sphere color.
---@param color integer The sphere color ID to be changed to.
function Shooter:getSphere(color)
    if self.color ~= 0 then
        self:setColor(color)
    elseif self.nextColor ~= 0 then
        self:setNextColor(color)
    end
end



---Activates the multi-sphere mode and applies a given amount of spheres of a given color.
---@param color integer The sphere color ID to be changed to.
---@param count integer The amount of spheres of that color to be given.
function Shooter:getMultiSphere(color, count)
    self.multiColorColor = color
    self.multiColorCount = count
    self:setColor(0)
    self:setNextColor(0)
end





---Drawing callback function.
function Shooter:draw()
    -- FORK-SPECIFIC CHANGES:
    -- - shadowSprite is now optional.
    -- - All sprites are rotated by 180 degrees so they face down.
    -- - Different states for the shooter (warm overlay/hot/cannons)

    if self.shadowSprite then
        self.shadowSprite:draw(self.pos + self.config.shadowSpriteOffset:rotate(self.angle), self.config.shadowSpriteAnchor, nil, nil, self.angle+math.pi)
    end

    if not self.spriteAsOverlay then
        if _Game.session.level.blitzMeter >= 1 then
            self.hotSprite:draw(self.pos + self.config.spriteOffset:rotate(self.angle), self.config.spriteAnchor, nil, nil, self.angle+math.pi)
        else
            self.sprite:draw(self.pos + self.config.spriteOffset:rotate(self.angle), self.config.spriteAnchor, nil, nil, self.angle+math.pi)
        end
    end

    -- retical
    if _EngineSettings:getAimingRetical() then
        self:drawReticle()
    end

    if not self.spriteAsOverlay then
        -- Hot frog transitions
        if (_Game.session.level.blitzMeter < 1) and self.warmSprite then
            self.warmSprite:draw(self.pos + self.config.spriteOffset:rotate(self.angle), self.config.spriteAnchor, nil, nil, self.angle+math.pi, nil, _Game.session.level.blitzMeter)
        end
    end

    -- this color
    if self.sphereEntity and not self.shotCooldown then
        self.sphereEntity:setPos(self:getSpherePos())
        self.sphereEntity:setAngle(self.angle)
        self.sphereEntity:setScale(self:getSphereSize() / 32)
        self.sphereEntity:setFrame(self:getSphereFrame())
        self.sphereEntity:setAlpha(self:getSphereAlpha())
        self.sphereEntity:draw()
    end
    -- next color
    local sprite

    -- prevent crash if a particular next color is not defined in frogatar.
    if self.config.nextBallSprites[self.nextColor] == nil then 
        sprite = self.config.nextBallSprites[0].sprite
    else

        if _Game.runtimeManager.options:getColorblindMode() and self.config.nextBallSprites[self.nextColor].colorblindSprite then
            sprite = self.config.nextBallSprites[self.nextColor].colorblindSprite
        else
            sprite = self.config.nextBallSprites[self.nextColor].sprite
        end
    end
    
    sprite:draw(self.pos + self.config.nextBallOffset:rotate(self.angle), self.config.nextBallAnchor, nil, self:getNextSphereFrame(), self.angle+math.pi)

    -- Overlay sprite goes after colors.
    if self.overlaySprite and (not self.spriteAsOverlay) then
        if _Game.session.level.blitzMeter >= 1 then
            self.hotOverlaySprite:draw(self.pos + self.config.overlayOffset:rotate(self.angle), self.config
            .overlayAnchor, nil, nil, self.angle + math.pi)
        else
            self.overlaySprite:draw(self.pos + self.config.overlayOffset:rotate(self.angle), self.config.overlayAnchor,
            nil, nil, self.angle + math.pi)
            if self.warmOverlaySprite then
                self.warmOverlaySprite:draw(self.pos + self.config.overlayOffset:rotate(self.angle),
                self.config.overlayAnchor, nil, nil, self.angle + math.pi, nil, _Game.session.level.blitzMeter)
            end
        end
    elseif self.spriteAsOverlay then
        if _Game.session.level.blitzMeter >= 1 then
            self.hotSprite:draw(self.pos + self.config.spriteOffset:rotate(self.angle), self.config.spriteAnchor, nil, nil, self.angle+math.pi)
        else
            self.sprite:draw(self.pos + self.config.spriteOffset:rotate(self.angle), self.config.spriteAnchor, nil, nil, self.angle+math.pi)
        end
        if (_Game.session.level.blitzMeter < 1) and self.warmSprite then
            self.warmSprite:draw(self.pos + self.config.spriteOffset:rotate(self.angle), self.config.spriteAnchor, nil, nil, self.angle+math.pi, nil, _Game.session.level.blitzMeter)
        end
    end

	if _Debug.sphereDebugVisible2 then
		self:drawDebug()
	end
end

-- spirit animal transform draw functions
-- curTimer is the value of the spirit animal delay timer, start at 2.5, 500px at 2.25, 0 alpha at 1.5
function Shooter:drawSpiritTransformation(pos, curTimer)
    local radius = 0
    local alpha = 1
    if curTimer < 2.5 then
        radius = math.min((2.5 - curTimer) * 2500, 500)
    end 
    
    if curTimer < 2.25 then
        alpha = math.max(math.min((curTimer - 1.5) * 1.34, 1),0)
    end 

    love.graphics.setColor(1, 1, 1, alpha)
    love.graphics.circle("fill", pos.x, pos.y, radius, 100)
end

---Draws the speed shot beam.
function Shooter:drawSpeedShotBeam()
    -- rendering options:
    -- "full" - the beam is always fully visible
    -- "cut" - the beam is cut on the target position
    -- "scale" - the beam is squished between the shooter and the target position
    if self.speedShotAnim == 0 then
        return
    end

    local targetPos = self:getTargetPos()
    local maxDistance = self.speedShotSprite.size.y
    local distance = math.min(targetPos and (self.pos - targetPos):len() or maxDistance, maxDistance)
    local distanceUnit = distance / maxDistance
    local scale = Vec2(1)
    if self.config.speedShotBeam.renderingType == "scale" then
        -- if we need to scale the beam
        scale.y = distanceUnit
    elseif self.config.speedShotBeam.renderingType == "cut" then
        -- if we need to cut the beam
        -- make a polygon: determine all four corners first
        local p1 = _PosOnScreen(self.pos + Vec2(-self.speedShotSprite.size.x / 2, -distance):rotate(self.angle))
        local p2 = _PosOnScreen(self.pos + Vec2(self.speedShotSprite.size.x / 2, -distance):rotate(self.angle))
        local p3 = _PosOnScreen(self.pos + Vec2(self.speedShotSprite.size.x / 2, 16):rotate(self.angle))
        local p4 = _PosOnScreen(self.pos + Vec2(-self.speedShotSprite.size.x / 2, 16):rotate(self.angle))
        -- mark all pixels within the polygon with value of 1
        love.graphics.stencil(function()
            love.graphics.setColor(1, 1, 1)
            love.graphics.polygon("fill", p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, p4.x, p4.y)
        end, "replace", 1)
        -- mark only these pixels as the pixels which can be affected
        love.graphics.setStencilTest("equal", 1)
    end
    -- apply color if wanted
    local color = self.config.speedShotBeam.colored and self:getReticalColor() or Color()
    -- draw the beam
    self.speedShotSprite:draw(self:getSpherePos() + Vec2(0, 16):rotate(self.angle), Vec2(0.5, 1), nil, nil, self.angle, color, self.speedShotAnim, scale)
    -- reset the scissor
    if self.config.speedShotBeam.renderingType == "cut" then
        love.graphics.setStencilTest()
    end
end



---Draws the reticle.
function Shooter:drawReticle()
    local targetPos = self:getTargetPos()
    local color = self:getReticalColor()
    local sphereConfig = self:getSphereConfig()
    if targetPos and self.color ~= 0 and sphereConfig.shootBehavior.type == "normal" then
        if self.reticleSprite then
            local location = targetPos + (_ParseVec2(self.config.reticle.offset) or Vec2()):rotate(self.angle)
            self.reticleSprite:draw(location, Vec2(0.5, 0), nil, nil, self.angle, color)
            if self.reticleNextSprite then
                local nextColor = self:getNextReticalColor()
                local nextLocation = location + (_ParseVec2(self.config.reticle.nextBallOffset) or Vec2()):rotate(self.angle)
                self.reticleNextSprite:draw(nextLocation, Vec2(0.5, 0), nil, nil, self.angle, nextColor)
            end
        else
            love.graphics.setLineWidth(3 * _GetResolutionScale())
            love.graphics.setColor(color.r, color.g, color.b)
            local p1 = _PosOnScreen(targetPos + Vec2(-8, 8):rotate(self.angle))
            local p2 = _PosOnScreen(targetPos)
            local p3 = _PosOnScreen(targetPos + Vec2(8, 8):rotate(self.angle))
            love.graphics.line(p1.x, p1.y, p2.x, p2.y)
            love.graphics.line(p2.x, p2.y, p3.x, p3.y)
        end

        --_Game.resourceManager.

        -- Fireball range highlight
        if sphereConfig.hitBehavior.type == "fireball" or sphereConfig.hitBehavior.type == "colorCloud" then
            if self.radiusReticleSprite then
                local location = targetPos + (_ParseVec2(self.config.reticle.offset) or Vec2())
                local scale = Vec2(sphereConfig.hitBehavior.range * 2) / self.radiusReticleSprite.size
                self.radiusReticleSprite:draw(location, Vec2(0.5), nil, nil, nil, color, nil, scale)
            else
                --love.graphics.setColor(1, 0, 0)
                local dotCount = math.ceil(sphereConfig.hitBehavior.range / 12) * 4
                for i = 1, dotCount do
                    local angle = (2 * i * math.pi / dotCount) + _TotalTime / 2
                    local p = _PosOnScreen(targetPos + Vec2(sphereConfig.hitBehavior.range, 0):rotate(angle))
                    love.graphics.circle("fill", p.x, p.y, 2 * _GetResolutionScale())
                end
                --love.graphics.setLineWidth(3 * getResolutionScale())
                --love.graphics.circle("line", p2.x, p2.y, sphereConfig.hitBehavior.range)
            end
        end
    end
end



---Draws this Shooter's hitbox.
function Shooter:drawDebug()
    local p = _PosOnScreen(self.pos + self.config.hitboxOffset - self.config.hitboxSize / 2)
    local s = self.config.hitboxSize * _GetResolutionScale()
    love.graphics.rectangle("line", p.x, p.y, s.x, s.y)
end



---Spawns a sphere entity which is used to draw the primary sphere.
function Shooter:spawnSphereEntity()
    if self.color == 0 or self.sphereEntity then
        return
    end
    self.sphereEntity = SphereEntity(self:getSpherePos(), self.color)
end



---Returns the primary sphere color.
---@return table
function Shooter:getReticalColor()
    if not self:getSphereConfig() then
        return Color(1, 1, 1)
    end
    local color = self:getSphereConfig().color
    if type(color) == "string" then
        return _Game.resourceManager:getColorPalette(color):getColor(_TotalTime * self:getSphereConfig().colorSpeed)
    else
        return color
    end
end

---Returns the secondary sphere color.
---@return table
function Shooter:getNextReticalColor()
    local color = self:getNextSphereConfig().color
    if type(color) == "string" then
        return _Game.resourceManager:getColorPalette(color):getColor(_TotalTime * self:getNextSphereConfig().colorSpeed)
    else
        return color
    end
end



---Returns the initial position of this Shooter, based on its config.
---@return Vector2
function Shooter:getInitialPos()
    if self.movement.type == "linear" then
        return Vec2((self.movement.xMin + self.movement.xMax) / 2, self.movement.y)
    elseif self.movement.type == "circular" then
        return Vec2(self.movement.x, self.movement.y)
    end
    return Vec2()
end

---Returns the initial angle of this Shooter in radians, based on its config.
---@return number
function Shooter:getInitialAngle()
    if self.movement.type == "linear" then
        return self.movement.angle / 180 * math.pi
    elseif self.movement.type == "circular" then
        return 0
    end
    return 0
end



---Returns the center position of the primary sphere.
---@return Vector2
function Shooter:getSpherePos()
    return self.pos + self.config.ballPos:rotate(self.angle)
end



---Returns the diameter of the primary sphere.
function Shooter:getSphereSize()
    return self:getSphereConfig().size or 32
end



---Returns `true` if the given position is inside this Shooter's hitbox.
---@param pos Vector2 The position to be checked against.
---@return boolean
function Shooter:isPosCatchable(pos)
    return math.abs(self.pos.x - pos.x + self.config.hitboxOffset.x) < self.config.hitboxSize.x / 2 and math.abs(self.pos.y - pos.y + self.config.hitboxOffset.y) < self.config.hitboxSize.y / 2
end



---Returns the reticle position.
---@return Vector2
function Shooter:getTargetPos()
    return _Game.session:getNearestSphereOnLine(self.pos, self.angle).targetPos
end



---Returns the current effective shooting speed.
---@return number
function Shooter:getShootingSpeed()
    local sphereSpeed = self:getSphereConfig().shootSpeed
    if sphereSpeed then
        return sphereSpeed
    elseif self.speedShotTime > 0 then
        return self.speedShotSpeed
    end

    local foodSpeedShot_add = _Game.session.level:getParameter("shotSpeedBase")
    local foodSpeedShot_mult = _Game.session.level:getParameter("shotSpeedMultiplier")

    -- force the shot speed multiplier to be a minimum of 10% 
    foodSpeedShot_mult = math.max(foodSpeedShot_mult, 0.1)

    -- TODO: What's the order of speed shot multipliers?

    -- modify the speed bonus based on the blitz meter
    -- Food will affect this by an amount. 
    
    -- Shot speed at 100% hot frog meter is 180% nomal shot speed, adjusted by food effect 
    local foodSpeedBonusVel_add = _Game.session.level:getParameter("speedUpShotsTotalIncrease")
    local speedBonusShotSpeed = math.max(_Game.session.level.blitzMeter - 0.5,0) * ((self.config.shootSpeed * 1.6) + foodSpeedBonusVel_add)

    local finalSpeed =  self.config.shootSpeed + foodSpeedShot_add + speedBonusShotSpeed
    finalSpeed = finalSpeed * (foodSpeedShot_mult)


    return finalSpeed
end



---Returns config for the current sphere.
---@return table
function Shooter:getSphereConfig()
    return _Game.configManager.spheres[self.color]
end



---Returns config for the next sphere.
---@return table
function Shooter:getNextSphereConfig()
    return _Game.configManager.spheres[self.nextColor]
end



---Returns the current sphere's animation frame.
---@return Vector2
function Shooter:getSphereFrame()
    local animationSpeed = self:getSphereConfig().spriteAnimationSpeed
    if animationSpeed then
        return Vec2(math.floor(animationSpeed * _TotalTime), 1)
    end
    return Vec2(1)
end



---Returns the current sphere's transparency. Used in shot cooldown fade animation.
---@return number
function Shooter:getSphereAlpha()
    if self.shotCooldownFade then
        return 1 - (self.shotCooldownFade / self.config.shotCooldownFade)
    end
    return 1
end



---Returns the next sphere's animation frame.
---@return Vector2
function Shooter:getNextSphereFrame()
    -- prevent crash if nextcolor is not defined
    if self.config.nextBallSprites[self.nextColor] == nil then
        return Vec2(1)
    end
    local animationSpeed = self.config.nextBallSprites[self.nextColor].spriteAnimationSpeed
    if animationSpeed then
        return Vec2(math.floor(animationSpeed * _TotalTime), 1)
    end
    return Vec2(1)
end



---Serializes this Shooter's data for saving purposes.
---@return table
function Shooter:serialize()
    return {
        color = self.color,
        nextColor = self.nextColor,
        multiColorColor = self.multiColorColor,
        multiColorCount = self.multiColorCount,
        speedShotTime = self.speedShotTime,
        speedShotSpeed = self.speedShotSpeed
    }
end



---Deserializes and loads previosly saved serialized data.
---@param t table
function Shooter:deserialize(t)
    self.color = t.color
    self.nextColor = t.nextColor
    self.multiColorColor = t.multiColorColor
    self.multiColorCount = t.multiColorCount
    self.speedShotTime = t.speedShotTime
    self.speedShotSpeed = t.speedShotSpeed



    self:spawnSphereEntity()
end



return Shooter
