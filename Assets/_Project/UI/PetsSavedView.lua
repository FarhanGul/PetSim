--!Type(UI)
local events = require("EventManager")
local save = require("SaveManager")
local data = require("GameData")
local helper = require("Helper")

--!Bind
local _progress : Label = nil

function self:Awake()
    events.SubscribeEvent(events.gameStart,UpdateProgress)
    events.SubscribeEvent(events.newDiscovery,UpdateProgress)
end

function UpdateProgress()
    _progress.text = helper.GetTableLength(save.pets).." / "..data.totalPets
end