--!Type(Module)
local events = require("EventManager")
local save = require("SaveManager")

local movePlayerToSceneRequest = Event.new("movePlayerToSceneRequest")

local scenes : {[number] : Scene} = {}

local function LoadScene(id : number)
    scenes[id] = server.LoadSceneAdditive(id)
end

function self:ServerStart()

    function MovePlayerToScene(player : Player, id : number)
		if scenes[id] == nil then
			LoadScene(id)
		end
		server.MovePlayerToScene(player, scenes[id])
	end

    movePlayerToSceneRequest:Connect(function(player,sceneId)
        MovePlayerToScene(player, sceneId)	
    end)

end

function self:ClientAwake()
end

function SendMovePlayerToSceneRequest(sceneId)
    movePlayerToSceneRequest:FireServer(sceneId)
end