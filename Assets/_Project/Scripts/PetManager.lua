--!Type(Client)
local uiController = require("UIController")
local uiComponents = require("UIComponents")
local events = require("EventManager")
local save = require("SaveManager")

--!SerializeField
local petPrefabs : { GameObject } = {}

function self:Awake()
    events.SubscribeEvent(events.newPet,function(args)
        Spawn(args[1])
    end)
end

function self:Start()
    if(save.equippedPet ~= nil) then
        Spawn(Vector3.zero)
    end
end

function Spawn(position)
    local perfab = GetPrefabFromName(save.equippedPet)
    local pet = Object.Instantiate(perfab)
    pet.transform.position = position
    pet.name = perfab.name
    events.InvokeEvent(events.petSpawned,pet)
end

function GetPrefabFromName(name)
    for i = 1, #petPrefabs do
        if(petPrefabs[i].name == name) then
            return petPrefabs[i]
        end
    end
end