--!Type(Module)
local events = require("EventManager")
local data = require("GameData")

coins = 0
currentObjective = {}
pets = {}

function Initialize()
    currentObjective = data.objectives.firstEgg
end

function SetCoins(newValue)
    coins = newValue
    events.InvokeEvent(events.currencyUpdated)
end

function AddPetXp(petId, delta)
    pets[petId].xp += delta
    events.InvokeEvent(events.petXpUpdated,petId,delta)
end

function PetData()
    local this = {}
    this.xp = 0
    this.isEquipped = true
    return this
end