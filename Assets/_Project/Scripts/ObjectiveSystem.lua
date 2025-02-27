--!Type(Client)

local events = require("EventManager")
local data = require("GameData")
local save = require("SaveManager")
local helper = require("Helper")

--!SerializeField
local view : ObjectiveView = nil

function self:Awake()
    events.SubscribeEvent(events.objectiveCompleted,UpdateView)
    events.SubscribeEvent(events.gameStart,UpdateView)
end

function UpdateView(args)
    view.Set(helper.GetValue(data.objectives,save.currentObjective).text)
end