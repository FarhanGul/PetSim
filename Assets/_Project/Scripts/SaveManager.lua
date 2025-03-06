--!Type(Module)
local events = require("EventManager")
local data = require("GameData")
local helper = require("Helper")

coins = 100
currentObjective = "firstEgg"
pets = {}
equippedPet = nil
hiddenObjectIds = {}

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
    pet.hunger -= delta
    if(pet.hunger <=0) then
        pets[equippedPet].status = "Playful"
        events.InvokeEvent(events.petStatusUpdated)
    end
    if(pet.xp >= data.firstfeedObjectiveXpRequirement)then
        CompleteObjective("firstFeed")
    end
    events.InvokeEvent(events.petXpUpdated)
end

function NewPet(petName,spawnPosition)
    pets[petName] = PetData()
    pets[petName].status = "Hungry"
    equippedPet = petName
    events.InvokeEvent(events.newPet,spawnPosition)
end

function PetData()
    local this = {}
    this.xp = 0
    this.status = nil
    this.hunger = 16
    return this
end

function CompleteObjective(objective)
    if(currentObjective == objective)then
        currentObjective = helper.GetNextKey(data.objectives,objective)
        events.InvokeEvent(events.objectiveCompleted)
    end
end
