--!Type(ClientAndServer)
local events = require("EventManager")

function self:ClientStart()
    events.InvokeEvent(events.gameStart)
end