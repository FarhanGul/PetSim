--!Type(Module)
local events = require("EventManager")
local data = require("GameData")
local helper = require("Helper")

-- NOTE : Make sure to update GameLauncher when updating save data
currentObjective = "introDialogue"
pets = {}
equippedPet = nil
discoveredObjectIds = {}
discoveredAnimationIds = {}
day = 1
canPoke = false
canEat = false
canPlay = false

function NextDay()
    day += 1
    events.InvokeEvent(events.saveGame)
end

function AddDiscoveredObject(objectId)
    table.insert(discoveredObjectIds,objectId)
    events.InvokeEvent(events.saveGame)
end

function AddDiscoveredAnimation(animationId)
    table.insert(discoveredAnimationIds,animationId)
    events.InvokeEvent(events.saveGame)
end

function AddPetXp(delta)
    local pet = pets[equippedPet]
    pet.xp += delta
    events.InvokeEvent(events.petXpUpdated)
    if(pet.xp >= data.firstfeedObjectiveXpRequirement)then
        CompleteObjective("firstFeed")
    else
        events.InvokeEvent(events.saveGame)
    end
end

function ChangePet(petName)
    equippedPet = petName
    events.InvokeEvent(events.spawnPet,nil)
    events.InvokeEvent(events.saveGame)
end

function NewPet(petName,spawnPosition)
    pets[petName] = PetData()
    equippedPet = petName
    events.InvokeEvent(events.spawnPet,spawnPosition)
    events.InvokeEvent(events.saveGame)
end

function CompleteObjective(objective)
    if(currentObjective == objective)then
        if(currentObjective == "introDialogue") then canPoke = true
        elseif(currentObjective == "firstEgg") then canEat = true
        elseif(currentObjective == "firstFeed") then 
            canPlay = true
            canEat = false
        elseif(currentObjective == "firstPlay") then 
            canEat = true
        end
        currentObjective = helper.GetNextKey(data.objectives,objective)
        events.InvokeEvent(events.objectiveCompleted)
        events.InvokeEvent(events.saveGame)
    end
end

function PetData()
    local this = {}
    this.xp = 0
    return this
end

