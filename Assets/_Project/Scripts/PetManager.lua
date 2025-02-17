--!Type(Client)
local uiController = require("UIController")
local uiComponents = require("UIComponents")
local events = require("EventManager")

--!SerializeField
local petPrefabs : { GameObject } = {}

function self:ClientAwake()
    events.SubscribeEvent(events.boughtEgg,function(args)
        Spawn()
    end)
end

function Initialize()

end

function Spawn()
    local pet = Object.Instantiate( petPrefabs[math.random(1,#petPrefabs)])
end