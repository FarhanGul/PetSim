--!Type(UI)
local events = require("EventManager")
local data = require("GameData")

--!Bind
local _root : VisualElement = nil
--!Bind
local _title : Label = nil
--!Bind
local _level : Label = nil
--!Bind
local _description : Label = nil
--!Bind
local _playButton : UIButton = nil

function self:Start()
    events.InvokeEvent(events.registerReadyToPlayView,self)
    Hide()
end

function Show(miniGameData)
    _root:SetDisplay(true)
    _title.text = miniGameData.title
    _level.text = "Level "..miniGameData.level
    _description.text = miniGameData.description
end

function Hide()
    _root:SetDisplay(false)
end