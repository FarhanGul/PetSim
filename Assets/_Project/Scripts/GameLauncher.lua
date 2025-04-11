--!Type(Module)
local save = require("SaveManager")
local data = require("GameData")
local sceneLoader = require("CustomSceneLoader")

local saveFileName = "SaveFile"
local gameStartResponse = Event.new("gameStartResponse")
local saveRequest = Event.new("saveRequest")
local getSaveRequest = Event.new("getSaveRequest")

function self:ClientAwake()
    gameStartResponse:Connect(function(saveData)
        ClientLoadGame(saveData)
    end)
end

function self:ClientStart()
    getSaveRequest:FireServer()
end

function self:ServerAwake()
    saveRequest:Connect(function(player, saveData)
        Storage.SetPlayerValue(player,saveFileName,saveData)
    end)
    getSaveRequest:Connect(function(player)
        Storage.GetPlayerValue(player, saveFileName, function(saveData)
            if(saveData == nil) then
                saveData = GetSaveData()
                Storage.SetPlayerValue(player,saveFileName,saveData)
            end
            gameStartResponse:FireClient(player, saveData)
        end)
    end)
end

function SaveGame()
    saveRequest:FireServer(GetSaveData())
end

function ClientLoadGame(saveData)
    save.currentObjective = saveData.currentObjective
    save.pets = saveData.pets
    save.equippedPet = saveData.equippedPet
    save.canPoke = saveData.canPlay
    save.canEat = saveData.canEat
    save.canPlay = saveData.canPlay
    save.coins = saveData.coins
    save.simonSaysHighscore = saveData.simonSaysHighscore
    save.currentLocation = saveData.currentLocation
    save.maps = saveData.maps
    sceneLoader.SendMovePlayerToSceneRequest(saveData.currentLocation)
end

function GetSaveData()
    return {
        currentObjective = save.currentObjective,
        pets = save.pets,
        equippedPet = save.equippedPet,
        canPoke = save.canPlay,
        canEat = save.canEat,
        canPlay = save.canPlay,
        coins = save.coins,
        simonSaysHighscore = save.simonSaysHighscore,
        currentLocation = save.currentLocation,
        maps = save.maps
    }
end