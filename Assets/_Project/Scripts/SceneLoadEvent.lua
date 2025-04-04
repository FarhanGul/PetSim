--!Type(Client)
local events = require("EventManager")
local data = require("GameData")
local save = require("SaveManager")

function self:Start()
    if(save.currentLocation == "Island2") then
        save.CompleteObjective("getBackToTheBoat")
    end
    data.totalDiscoveries = #GameObject.FindGameObjectsWithTag("Discovery")
    events.InvokeEvent(events.gameStart)
    events.InvokeEvent(events.lateGameStart)
end

