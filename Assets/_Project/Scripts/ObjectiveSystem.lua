--!Type(Client)

local events = require("EventManager")
local data = require("GameData")
local save = require("SaveManager")
local helper = require("Helper")


function self:Awake()
    events.SubscribeEvent(events.objectiveCompleted,UpdateView)
    events.SubscribeEvent(events.gameStart,UpdateView)
end

function UpdateView(args)
    local hint = helper.GetValue(data.objectives,save.currentObjective).text
end