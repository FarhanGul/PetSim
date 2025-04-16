--!Type(Client)
local events = require("EventManager")
local data = require("GameData")
local save = require("SaveManager")
local launcher = require("GameLauncher")
local petManager = require("PetManager")

local savePending = false

function self:ClientAwake()
    events.SubscribeEvent(events.saveGame,function(args)
        savePending = true
    end)
end

function self:Start()
    if(save.currentLocation == "Island2") then
        save.CompleteObjective("getBackToTheBoat")
    end
    data.totalDiscoveries = #GameObject.FindGameObjectsWithTag("Discovery")
    events.InvokeEvent(events.gameStart)
    petManager.HandleGameStart()
    events.InvokeEvent(events.lateGameStart)
end

function self:LateUpdate()
    if(savePending) then
        launcher.SaveGame()
        savePending = false;
    end
end
