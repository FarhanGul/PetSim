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

function self:Start()
    events.InvokeEvent(events.registerFoodView,self)
    Hide()
end

function SetProgress(label,pc)
    _xpLabel.text = label
    _xpFill.style.width = StyleLength.new(Length.Percent(pc*70))
end

function Show(name,xpGained)
    _foodName.text = name
    _xpReward.text = xpGained
    _root:SetDisplay(true)
end

function Hide()
    _root:SetDisplay(false)
end