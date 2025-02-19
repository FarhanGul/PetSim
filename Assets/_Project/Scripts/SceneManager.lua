--!Type(ClientAndServer)
local events = require("EventManager")
local save = require("SaveManager")
local gameEvents = require("EventManager")

local networkEvents = {
    sendMoveRequestToServer = Event.new("sendMoveRequestToServer"),
    sendMoveCommandToClient = Event.new("sendMoveCommandToClient"),
    sendChangeSceneRequestToServer = Event.new("sendChangeSceneRequestToServer"),
}

function self:ServerAwake()
    networkEvents.sendMoveRequestToServer:Connect(function(player,newPlayerPosition)
        player.character.transform.position = newPlayerPosition
        networkEvents.sendMoveCommandToClient:FireAllClients(player,newPlayerPosition)
    end)
    networkEvents.sendChangeSceneRequestToServer:Connect(function(player,sceneName)
        print("Server Recieved Scene change request "..sceneName)
        local scene = server.LoadScene(sceneName,false)
        server.MovePlayerToScene(player, scene)
    end)
end

function self:ClientAwake()
    gameEvents.SubscribeEvent(gameEvents.changeScene,function(args)
        print("Client sending change scene request "..args[1])
        networkEvents.sendChangeSceneRequestToServer:FireServer(args[1])
    end)
    networkEvents.sendMoveCommandToClient:Connect(function(player,newPlayerPosition)
        SetPlayerPositionOnClient(player,newPlayerPosition)
    end)
end

function SetPlayerPositionOnClient(player,newPosition)
    player.character.usePathfinding = false
    player.character:Teleport(newPosition,function() end)
    player.character.usePathfinding = true
end