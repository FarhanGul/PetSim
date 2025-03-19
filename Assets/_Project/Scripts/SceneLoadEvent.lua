--!Type(Client)
local events = require("EventManager")

function self:Start()
    events.InvokeEvent(events.gameStart)
    events.InvokeEvent(events.lateGameStart)
end

