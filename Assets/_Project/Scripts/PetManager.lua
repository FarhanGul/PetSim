--!Type(Module)
local events = require("EventManager")
local save = require("SaveManager")

local spawnResponse = Event.new("spawnResponse")
local spawnRequest = Event.new("spawnRequest")
local leaveIslandResponse = Event.new("leaveIslandResponse")
local leaveIslandRequest = Event.new("leaveIslandRequest")

--!SerializeField
local petPrefabs : { GameObject } = {}

local activePets = {}

function self:ServerAwake()
    spawnRequest:Connect(function(player,position,petName,location)
        spawnResponse:FireAllClients(player,position,petName,location)
    end)
    leaveIslandRequest:Connect(function(player)
        leaveIslandResponse:FireAllClients(player)
    end)
end

function self:ClientAwake()
    spawnResponse:Connect(function(player,position,petName,location)
        if(save.currentLocation == location) then
            Spawn(player,position,petName)
        end
    end)
    client.PlayerDisconnected:Connect(function(player)
        if(activePets[player]~=nil)then
            GameObject.Destroy(activePets[player].gameObject)
            table.remove(activePets,player)
        end
    end)
    leaveIslandResponse:Connect(function(playerWhoLeft)
        if(activePets[playerWhoLeft] ~= nil) then
            GameObject.Destroy(activePets[playerWhoLeft].gameObject)
        end
        activePets[playerWhoLeft] = nil
    end)
end

function ChangePet(petName)
    save.equippedPet = petName
    spawnRequest:FireServer(activePets[client.localPlayer].transform.position,petName,save.currentLocation)
end

function NewPet(petName,spawnPosition)
    save.pets[petName] = PetData()
    equippedPet = petName
    spawnRequest:FireServer(spawnPosition,petName,save.currentLocation)
    events.InvokeEvent(events.saveGame)
end

function HandleLeavingIsland()
    leaveIslandRequest:FireServer()
end

function HandleGameStart()
    if(save.equippedPet ~= nil) then
        local spawnPos = client.localPlayer.character.transform.position + Vector3.forward * 2
        spawnRequest:FireServer(spawnPos,save.equippedPet,save.currentLocation)
    end
end

function Spawn(targetPlayer : Player, spawnPosition,petName : string)
    local perfab = GetPrefabFromName(petName)
    if(activePets[targetPlayer] ~= nil) then
        GameObject.Destroy(activePets[targetPlayer].gameObject)
    end
    local pet = Object.Instantiate(perfab):GetComponent(IslandPet)
    pet.transform.position = spawnPosition
    pet.name = perfab.name
    pet.SetTarget(targetPlayer.character.transform)
    activePets[targetPlayer] = pet
    if(targetPlayer == client.localPlayer) then
        events.InvokeEvent(events.localPetSpawned,pet)
    end
end

function GetPrefabFromName(name)
    for i = 1, #petPrefabs do
        if(petPrefabs[i].name == name) then
            return petPrefabs[i]
        end
    end
end

function NewMemory()
    local this = {}
    dictionary = {}

    function this.GetExistingPets(island)
        -- Returns all pets on this island
    end

    function this.Add(_player,_petName,_island)
        dictionary[_player] = {
            petName = _petName,
            islandName = _island
        }
    end

    function this.Remove(_player)
        -- Player has disconnected remove orphan pets
    end
    return this
end

function PetData()
    local this = {}
    this.xp = 0
    return this
end
