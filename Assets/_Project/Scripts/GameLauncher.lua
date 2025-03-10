--!Type(ClientAndServer)
local events = require("EventManager")
local save = require("SaveManager")

function self:ClientStart()
    save.LoadGame(function()
        events.InvokeEvent(events.gameStart)
        events.InvokeEvent(events.lateGameStart)
    end)
end