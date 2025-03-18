--!Type(ClientAndServer)
local events = require("EventManager")
local save = require("SaveManager")
local data = require("GameData")

local saveFileName = "SaveFile"
local gameStartResponse = Event.new("gameStartResponse")
local saveRequest = Event.new("saveRequest")
local getSaveRequest = Event.new("getSaveRequest")

function self:ClientAwake()
    events.SubscribeEvent(events.saveGame,function(args)
        saveRequest:FireServer(GetSaveData())
    end)
    gameStartResponse:Connect(function(saveData)
        ClientLoadGame(saveData)
    end)
end

function self:ClientStart()
    getSaveRequest:FireServer()

end

function self:ServerAwake()
    saveRequest:Connect(function(player, saveData)
        print("<color=red>Data Saved</color>")
        Storage.SetPlayerValue(player,saveFileName,saveData)
    end)
    getSaveRequest:Connect(function(player)
        Storage.GetPlayerValue(player, saveFileName, function(saveData)
            if(saveData == nil) then
                saveData = GetSaveData()
                print("<color=red>Data Saved</color>")
                Storage.SetPlayerValue(player,saveFileName,saveData)
            end
            gameStartResponse:FireClient(player, saveData)
        end)
    end)
end

function ClientLoadGame(saveData)
    save.currentObjective = saveData.currentObjective
    save.pets = saveData.pets
    save.equippedPet = saveData.equippedPet
    save.discoveredObjectIds = saveData.discoveredObjectIds
    save.discoveredAnimationIds = saveData.discoveredAnimationIds
    save.day = saveData.day
    events.InvokeEvent(events.gameStart)
    events.InvokeEvent(events.lateGameStart)
    print("<color=purple>Client recieved save file</color>")
end

function GetSaveData()
    return {
        currentObjective = save.currentObjective,
        pets = save.pets,
        equippedPet = save.equippedPet,
        discoveredObjectIds = save.discoveredObjectIds,
        discoveredAnimationIds = save.discoveredAnimationIds,
        day = save.day
    }
end