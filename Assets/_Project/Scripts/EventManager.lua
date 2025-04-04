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

function Clear()
    events = {}
end

-- Events
boughtEgg = "boughtEgg"
boughtPetFood = "boughtPetFood"
gameStart = "gameStart"
lateGameStart = "lateGameStart"
currencyUpdated = "currencyUpdate"
petXpUpdated = "petXpUpdated"
changeScene = "changeScene" -- sceneName
objectiveCompleted = "objectiveCompleted"
petSpawned = "petSpawned" -- pet
spawnPet = "spawnPet" -- spawnPosition
registerActivityView = "registerActivityView" -- activityView
registerReadyToPlayView = "registerReadyToPlayView" -- readyToPlayView
registerPetSelectionView = "registerPetSelectionView" -- petSelectionView
registerBuyItemView = "registerBuyItemView" -- buyItemView
registerLocationSelectionView = "registerLocationSelectionView" -- locationSelectionView
petTargetUpdated = "petTargetUpdated" -- followPlayer
simonSayTrigger = "simonSayTrigger" -- triggerId
petSwitcherOpened = "petSwitcherOpened"
newDiscovery = "newDiscovery"
saveGame = "saveGame"
nextDay = "nextDay"
coinsUpdated = "coinsUpdated"