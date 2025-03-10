--!Type(Module)
local events = require("EventManager")
local data = require("GameData")
local helper = require("Helper")

coins = 100
currentObjective = "firstEgg"
pets = {}
equippedPet = nil
hiddenObjectIds = {}
gameLevels = {
    simonSays = 1
}

function LoadGame(onGameLoaded)
    onGameLoaded()
end

function SetCoins(newValue)
    coins = newValue
    events.InvokeEvent(events.currencyUpdated)
end

function AddHiddenObject(objectId)
    table.insert(hiddenObjectIds,objectId)
end

function AddPetXp(delta)
    local pet = pets[equippedPet]
    pet.xp += delta
    if(pet.xp >= data.firstfeedObjectiveXpRequirement)then
        CompleteObjective("firstFeed")
    end
    events.InvokeEvent(events.petXpUpdated)
end

function NewPet(petName,spawnPosition)
    pets[petName] = PetData()
    equippedPet = petName
    events.InvokeEvent(events.newPet,spawnPosition)
end

function PetData()
    local this = {}
    this.xp = 0
    return this
end

function CompleteObjective(objective)
    if(currentObjective == objective)then
        currentObjective = helper.GetNextKey(data.objectives,objective)
        events.InvokeEvent(events.objectiveCompleted)
    end
end
