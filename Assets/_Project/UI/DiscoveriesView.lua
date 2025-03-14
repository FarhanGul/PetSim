--!Type(UI)
local events = require("EventManager")
local save = require("SaveManager")
local data = require("GameData")

--!Bind
local _progress : Label = nil

function self:Awake()
    events.SubscribeEvent(events.gameStart,UpdateProgress)
    events.SubscribeEvent(events.foodConsumed,UpdateProgress)
    events.SubscribeEvent(events.gameFinished,UpdateProgress)
    events.SubscribeEvent(events.eggHatched,UpdateProgress)
end

function UpdateProgress()
    _progress.text = #save.discoveredObjectIds.." / "..data.discoveries.starter
end