--!Type(Module)
local events = require("EventManager")
local data = require("GameData")
local helper = require("Helper")
local audio = require("AudioManager")

-- NOTE : Make sure to update GameLauncher when updating save data
coins = 0
currentObjective = "introDialogue"
pets = {}
equippedPet = nil
canPoke = false
canEat = false
canPlay = false
simonSaysHighscore = 0
currentLocation = "Island1"
maps = {"Island1"}

function AddDiscoveredObject(objectId)
end

function AddDiscoveredAnimation(animationId)
end

function UpdateLocation(newLocation)
    currentLocation = newLocation
    events.InvokeEvent(events.saveGame)
end

function AddMap(mapId)
    table.insert(maps,mapId)
    events.InvokeEvent(events.saveGame)
end

function SetSimonSaysNewHighscore(newScore)
    simonSaysHighscore = newScore
    events.InvokeEvent(events.saveGame)
end

function AddPetXp(delta)
    audio.Play("Grow")
    local pet = pets[equippedPet]
    local oldXp = pet.xp
    pet.xp += delta
    
    local oldLevel = 1
    local newLevel = 1
    for i, threshold in ipairs(data.petXpProgression) do
        if oldXp >= threshold then
            oldLevel = i + 1
        end
        if pet.xp >= threshold then
            newLevel = i + 1
        end
    end
    
    -- Give rewards for each level gained
    if newLevel > oldLevel then
        -- Loop through each level gained and give appropriate reward
        local totalReward = 0
        for level = oldLevel + 1, newLevel do
            totalReward += data.currencyRewardForLevelUp[level-1]
        end
        ChangeCoins(totalReward)
    end


    
    events.InvokeEvent(events.petXpUpdated)
    events.InvokeEvent(events.saveGame)
end

function ChangePet(petName)
    equippedPet = petName
    events.InvokeEvent(events.spawnPet,nil)
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
        elseif(currentObjective == "firstFeed") then canPlay = true
        end
        currentObjective = helper.GetNextKey(data.objectives,objective)
        events.InvokeEvent(events.objectiveCompleted)
        events.InvokeEvent(events.saveGame)
    end
end

function ChangeCoins(delta)
    if(delta > 0) then
        audio.Play("Shells")
        audio.Play("LevelUp")
    end
    coins += delta
    events.InvokeEvent(events.coinsUpdated)
    events.InvokeEvent(events.saveGame)
end

function PetData()
    local this = {}
    this.xp = 0
    return this
end

