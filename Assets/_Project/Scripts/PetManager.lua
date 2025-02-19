--!Type(Client)
local uiController = require("UIController")
local uiComponents = require("UIComponents")
local events = require("EventManager")
local save = require("SaveManager")

--!SerializeField
local petPrefabs : { GameObject } = {}

local equippedPet

function self:ClientAwake()
    events.SubscribeEvent(events.boughtEgg,function(args)
        Spawn()
    end)
    events.SubscribeEvent(events.boughtPetFood,function(args)
        save.AddPetXp(equippedPet,25)
    end)
end

function Spawn()
    local prefab = petPrefabs[math.random(1,#petPrefabs)]
    save.pets[prefab.name] = save.PetData()
    local pet = Object.Instantiate(prefab)
    pet.name = prefab.name
    equippedPet = prefab.name
end