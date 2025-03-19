--!Type(Client)
local uiController = require("UIController")
local uiComponents = require("UIComponents")
local events = require("EventManager")
local save = require("SaveManager")

--!SerializeField
local petPrefabs : { GameObject } = {}

local activePet : Pet = nil

function self:Awake()
    events.SubscribeEvent(events.gameStart,function(args)
        if(save.equippedPet ~= nil) then
            Spawn(client.localPlayer.character.transform.position + Vector3.forward * 2)
        end
    end)
    events.SubscribeEvent(events.spawnPet,function(args)
        Spawn(args[1])
    end)
end

function self:OnDestroy()
    activePet = nil
end

function Spawn(position)
    if(position == nil) then
        position = activePet.transform.position
    end
    if(activePet ~= nil) then
        GameObject.Destroy(activePet.gameObject)
    end
    local perfab = GetPrefabFromName(save.equippedPet)
    activePet = Object.Instantiate(perfab):GetComponent(Pet)
    activePet.transform.position = position
    activePet.name = perfab.name
    events.InvokeEvent(events.petSpawned,activePet)
end

function GetPrefabFromName(name)
    for i = 1, #petPrefabs do
        if(petPrefabs[i].name == name) then
            return petPrefabs[i]
        end
    end
end