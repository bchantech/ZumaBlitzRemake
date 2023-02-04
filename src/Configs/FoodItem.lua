local class = require "com/class"

---@class FoodItem
---@overload fun(data, path):FoodItem
local FoodItem = class:derive("FoodItem")

-- Place your imports here



function FoodItem:new(data, path)
    self._path = path
    self._name = nil -- Only used for self-reference; assigned in ConfigManager.lua
    self.displayName = data.displayName
    self.sprite = data.sprite
    self.price = data.price or 10000
    self.variants = data.variants
    self.variantBase = nil
    self.effects = data.effects
end



function FoodItem:syncVariantEffects()
    if self.variantBase then
        self.effects = _Game.configManager.foodItems[self.variantBase].effects
    end
end



return FoodItem