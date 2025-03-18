--!Type(ClientAndServer)
local events = require("EventManager")
local save = require("SaveManager")
local gameEvents = require("EventManager")

local movePlayerRequest = Event.new("movePlayerRequest")
local movePlayerResponse = Event.new("movePlayerResponse")

--!SerializeField
local cameraRoot : GameObject = nil
--!SerializeField
local dayGameObjects : { GameObject } = {}

function self:ServerAwake()
    movePlayerRequest:Connect(function(player,newPlayerPosition)
        player.character.transform.position = newPlayerPosition
        movePlayerResponse:FireAllClients(player,newPlayerPosition)
    end)
end

function self:ClientAwake()
    events.SubscribeEvent(events.gameStart,function(args)
        SetDay()
    end)
    events.SubscribeEvent(events.nextDay,function(args)
        save.NextDay()
        SetDay()
    end)
    movePlayerResponse:Connect(function(player,newPlayerPosition)
        player.character.usePathfinding = false
        player.character:Teleport(newPlayerPosition,function() end)
        player.character.usePathfinding = true
        if(player == client.localPlayer) then
            events.InvokeEvent(events.localPlayerTeleported)
            cameraRoot:GetComponent("RTSCamera").CenterOn(newPlayerPosition)
        end
    end)
end

function SetDay()
    for i = 1 , #dayGameObjects do
        dayGameObjects[i]:SetActive(i == save.day)
    end
    movePlayerRequest:FireServer(dayGameObjects[save.day].transform:Find("SpawnPoint").position)
end

