--!Type(Client)
local events = require("EventManager")
local data = require("GameData")

function self:Start()
    data.totalDiscoveries = #GameObject.FindGameObjectsWithTag("Discovery")
    events.InvokeEvent(events.gameStart)
    events.InvokeEvent(events.lateGameStart)
end

