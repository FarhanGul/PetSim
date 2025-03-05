--!Type(UI)
local events = require("EventManager")
local data = require("GameData")

--!Bind
local _root : VisualElement = nil
--!Bind
local _xpLabel : Label = nil
--!Bind
local _foodName : Label = nil
--!Bind
local _xpReward : Label = nil
--!Bind
local _xpFill : VisualElement = nil

local foodData

function self:Start()
    events.InvokeEvent(events.registerFoodView,self)
    Hide()
end

function SetProgress(amount)
    _xpLabel.text = tostring(amount).." s";
    _xpFill.style.width = StyleLength.new(Length.Percent(((foodData.timeRequiredToConsume - amount)/foodData.timeRequiredToConsume)*70))
end

function Show(foodId)
    foodData = data.foods[foodId]
    _foodName.text = foodData.name
    _xpReward.text = foodData.xpGained
    _root:SetDisplay(true)
end

function Hide()
    _root:SetDisplay(false)
end