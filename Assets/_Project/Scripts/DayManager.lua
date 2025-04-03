--!Type(ClientAndServer)
local events = require("EventManager")
local save = require("SaveManager")
local gameEvents = require("EventManager")

changeSceneRequest = Event.new("changeSceneRequest")

function self:ServerAwake()
    changeSceneRequest:Connect(function(player,sceneName)
        print("Server Recieved Scene change request "..sceneName)
        local scene = server.LoadScene(sceneName,false)
        server.MovePlayerToScene(player, scene)
    end)
end

function self:ClientAwake()
    events.SubscribeEvent(events.nextDay,function(args)
        save.NextDay()
        changeSceneRequest:FireServer(args[1])
    end)

end