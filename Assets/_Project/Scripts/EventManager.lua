--!Type(Module)

local events = {}

function InvokeEvent(eventName,...)
    if(events[eventName] ~= nil) then
        local args = {...}
        for i = 1 , #events[eventName] do
            events[eventName][i](args)
        end
    end
end

function SubscribeEvent(eventName,callback)
    if(events[eventName] == nil) then events[eventName] = {} end
    table.insert(events[eventName],callback)
end

function UnsubscribeEvent(eventName,callback)
    if(events[eventName] == nil) then events[eventName] = {} end
    local index = table.find(events[eventName],callback)
    if(index ~= nil) then table.remove(events[eventName],index) end
end

-- Events
boughtEgg = "boughtEgg"
boughtPetFood = "boughtPetFood"
gameStart = "gameStart"
currencyUpdated = "currencyUpdate"
petXpUpdated = "petXpUpdated"
changeScene = "changeScene" -- sceneName
objectiveCompleted = "objectiveCompleted"
petSpawned = "petSpawned" -- pet
newPet = "newPet" -- spawnPosition
petInteraction = "petInteraction" -- sourceId
followPlayer = "followPlayer"
petStatusUpdated = "petStatusUpdated"