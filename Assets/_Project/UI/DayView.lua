--!Type(UI)
local events = require("EventManager")
local save = require("SaveManager")
local data = require("GameData")
local helper = require("Helper")

--!Bind
local _day : Label = nil
--!Bind
local _panel : VisualElement = nil
--!Bind
local _sleepButton : UIButton = nil

function self:Awake()
    _sleepButton:RegisterPressCallback(function()
        events.InvokeEvent(events.nextDay)
    end)
    events.SubscribeEvent(events.gameStart,Update)
    events.SubscribeEvent(events.newDiscovery,Update)
end

function Update()
    _day.text = save.day
    local isDayFinished = #save.discoveredObjectIds == data.totalDiscoveries
    _panel:SetDisplay(not isDayFinished)
    _sleepButton:SetDisplay(isDayFinished)
end