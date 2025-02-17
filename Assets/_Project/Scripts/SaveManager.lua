--!Type(Module)
local events = require("EventManager")

coins = 0

function SetCoins(newValue)
    coins = newValue
    events.InvokeEvent(events.currencyUpdated)
end