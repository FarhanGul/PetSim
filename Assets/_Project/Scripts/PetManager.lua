--!Type(Module)
local events = require("EventManager")
local save = require("SaveManager")

local spawnResponse = Event.new("spawnResponse")
local spawnRequest = Event.new("spawnRequest")
local getActivePetsRequest = Event.new("getActivePetsRequest")
local getActivePetsResponse = Event.new("getActivePetsResponse")
local destroyOrphanPetResponse = Event.new("destroyOrphanPetResponse")

--!SerializeField
local petPrefabs : { GameObject } = {}

local activePets = {}
local serverActivePets = {}

function self:ServerAwake()
    spawnRequest:Connect(function(player,data)
        serverActivePets[player] = data
        spawnResponse:FireAllClients(player,data)
    end)
    server.PlayerDisconnected:Connect(function(player)
        ServerPlayerLeftIsland(player)
    end)
    getActivePetsRequest:Connect(function(player)
        getActivePetsResponse:FireClient(player,serverActivePets)
    end)
end

function self:ClientAwake()
    spawnResponse:Connect(function(player,data)
        if(save.currentLocation == data.location) then
            Spawn(player,data)
        end
    end)
    getActivePetsResponse:Connect(function(serverActivePetsCopy)
        activePets = {}
        for player, value in pairs(serverActivePetsCopy) do
            if(value.location == save.currentLocation) then
                value.spawnPosition = GetSpawnPositionNearToPlayer(player)
                Spawn(player, value)
            end
        end
        if(save.equippedPet ~= nil) then
            local spawnPos = GetSpawnPositionNearToPlayer(client.localPlayer)
            spawnRequest:FireServer({
                spawnPosition = spawnPos,
                petName = save.equippedPet,
                location = save.currentLocation,
                xp = save.pets[save.equippedPet].xp
            })
        end
    end)

    destroyOrphanPetResponse:Connect(function(player)
        if(activePets[player] ~= nil) then
            GameObject.Destroy(activePets[player].gameObject)
            activePets[player] = nil
        end
    end)
end

function ServerPlayerLeftIsland(player)
    if(serverActivePets[player] ~= nil) then
        local leavingPlayerLocation = serverActivePets[player].location
        serverActivePets[player] = nil
        -- Notify other players on this location to clean up pet
        for key, value in pairs(serverActivePets) do
            if(value.location == leavingPlayerLocation) then
                destroyOrphanPetResponse:FireClient(key,player)
            end
        end
    end
end

function ChangePet(_petName)
    save.equippedPet = _petName
    spawnRequest:FireServer({
        spawnPosition = activePets[client.localPlayer].transform.position,
        petName = _petName,
        location = save.currentLocation,
        xp = save.pets[_petName].xp
    })
end

function NewPet(_petName,_spawnPosition)
    save.pets[_petName] = PetData()
    save.equippedPet = _petName
    spawnRequest:FireServer({
        spawnPosition = _spawnPosition,
        petName = _petName,
        location = save.currentLocation,
        xp = save.pets[_petName].xp
    })
    events.InvokeEvent(events.saveGame)
end

function HandleGameStart()
    getActivePetsRequest:FireServer()
end

function GetSpawnPositionNearToPlayer(player : Player)
    return player.character.transform.position + Vector3.forward * 2
end

function Spawn(targetPlayer : Player, data)
    local prefab = GetPrefabFromName(data.petName)
    if(activePets[targetPlayer] ~= nil) then
        GameObject.Destroy(activePets[targetPlayer].gameObject)
    end
    local pet = Object.Instantiate(prefab):GetComponent(IslandPet)
    pet.transform.position = data.spawnPosition
    pet.name = prefab.name
    local staticXp = targetPlayer ~= client.localPlayer and data.xp or nil
    pet.Initialize(targetPlayer.character.transform,staticXp)
    activePets[targetPlayer] = pet
    if(targetPlayer == client.localPlayer) then
        events.InvokeEvent(events.localPetSpawned,pet)
        events.InvokeEvent(events.petTargetUpdated,true)
    end
end

function GetPrefabFromName(name)
    for i = 1, #petPrefabs do
        if(petPrefabs[i].name == name) then
            return petPrefabs[i]
        end
    end
end

function PetData()
    local this = {}
    this.xp = 0
    return this
end
