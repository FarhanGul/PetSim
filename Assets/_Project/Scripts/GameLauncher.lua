--!Type(ClientAndServer)
local events = require("EventManager")
local save = require("SaveManager")

function self:ClientStart()
    events.InvokeEvent(events.gameStart)
end