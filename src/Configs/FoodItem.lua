local class = require "com.class"

---@class FoodItem
---@overload fun(data, path):FoodItem
local FoodItem = class:derive("FoodItem")

-- Place your imports here



function FoodItem:new(data, path)
    self._path = path
    self._name = nil -- Only used for self-reference; assigned in ConfigManager.lua
    self.displayName = data.displayName or " "
    self.displayDescription = data.displayDescription or " "
    self.displayEffects = data.displayEffects or " "
    self.sprite = data.sprite
    self.price = data.price or 10000
    self.effects = data.effects
end



return FoodItem