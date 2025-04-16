--!Type(ClientAndServer)
local events = require("EventManager")
local save = require("SaveManager")

local spawnResponse = Event.new("spawnResponse")
local spawnRequest = Event.new("spawnRequest")

--!SerializeField
local petPrefabs : { GameObject } = {}

local activePet : IslandPet = nil

function self:ServerAwake()
    spawnRequest:Connect(function(player,position)
        print("Server sending response")
        spawnResponse:FireAllClients(player,position)
    end)
end

function self:ClientAwake()
    events.SubscribeEvent(events.gameStart,function(args)
        if(save.equippedPet ~= nil) then
            print("GameStart : Client sent spawn request")
            spawnRequest:FireServer(client.localPlayer.character.transform.position + Vector3.forward * 2)
        end
    end)
    events.SubscribeEvent(events.spawnPet,function(args)
        local position = args[1]
        if(position == nil) then
            position = activePet.transform.position
        end
        print("SpawnPet : Client sent spawn request")
        spawnRequest:FireServer(position)
    end)
    spawnResponse:Connect(function(player,position)
        Spawn(player, position)
    end)
    print("Client ready for server response")
end


function self:ClientOnDestroy()
    activePet = nil
end

function Spawn(targetPlayer : Player, spawnPosition)
    print(targetPlayer.name)
    print(tostring(spawnPosition))
    local perfab = GetPrefabFromName(save.equippedPet)
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