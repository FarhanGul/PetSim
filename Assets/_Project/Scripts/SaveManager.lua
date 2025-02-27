--!Type(Module)
local events = require("EventManager")
local data = require("GameData")
local helper = require("Helper")

coins = 100
-- currentObjective = "introDialogue"
currentObjective = "firstEgg"
pets = {}
eggs = {}

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

function EggData()
    local this = {}
    this.name = ""
    this.isHatching = false
    return this
end

function CompleteObjective(objective)
    if(currentObjective == objective)then
        currentObjective = helper.GetNextKey(data.objectives,objective)
        events.InvokeEvent(events.objectiveCompleted)
    end
end
