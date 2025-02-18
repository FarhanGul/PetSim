--!Type(Module)
local events = require("EventManager")
local data = require("GameData")

coins = 0
currentObjective = {}

function Initialize()
    currentObjective = data.objectives.firstEgg
end

function SetCoins(newValue)
    coins = newValue
    events.InvokeEvent(events.currencyUpdated)
end