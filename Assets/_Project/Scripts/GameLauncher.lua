--!Type(ClientAndServer)
local events = require("EventManager")
local save = require("SaveManager")

function self:ClientAwake()
    save.Initialize()
end

function self:ClientStart()
    events.InvokeEvent(events.gameStart)
end