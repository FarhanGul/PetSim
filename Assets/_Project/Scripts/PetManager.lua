--!Type(Module)
local events = require("EventManager")

local spawnResponse = Event.new("spawnResponse")
local spawnRequest = Event.new("spawnRequest")

--!SerializeField
local petPrefabs : { GameObject } = {}

local activePet : IslandPet = nil

function self:ServerAwake()
    spawnRequest:Connect(function(player,position,petName)
        spawnResponse:FireAllClients(player,position,petName)
    end)
end

function self:ClientAwake()
    spawnResponse:Connect(function(player,position,petName)
        Spawn(player,position,petName)
    end)
end

function HandleSpawnPet(spawnPos,petName)
    if(spawnPos == nil) then
        spawnPos = activePet.transform.position
    end
    spawnRequest:FireServer(spawnPos,petName)
end

function HandleGameStart(petName)
    activePet = nil
    if(petName ~= nil) then
        local spawnPos = client.localPlayer.character.transform.position + Vector3.forward * 2
        spawnRequest:FireServer(spawnPos,petName)
    end
end

function Spawn(targetPlayer : Player, spawnPosition,petName : string)
    local perfab = GetPrefabFromName(petName)
    if(targetPlayer == client.localPlayer and activePet ~= nil) then
        GameObject.Destroy(activePet.gameObject)
    end
    local pet = Object.Instantiate(perfab):GetComponent(IslandPet)
    pet.transform.position = spawnPosition
    pet.name = perfab.name
    pet.SetTarget(targetPlayer.character.transform)
    if(targetPlayer == client.localPlayer) then
        activePet = pet
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