--!Type(UI)
local events = require("EventManager")
local data = require("GameData")

--!Bind
local _root : VisualElement = nil
--!Bind
local _playButton : UIButton = nil
--!Bind
local _helpButton : UIButton = nil

local onPlay
local onHelp


function self:Start()
    events.InvokeEvent(events.registerReadyToPlayView,self)
    _playButton:RegisterPressCallback(function() onPlay() end)
    _helpButton:RegisterPressCallback(function() onHelp() end)
    Hide()
end

function Show(onPlayCallback,onHelpCallback)
    onPlay = onPlayCallback
    onHelp = onHelpCallback
    _root:SetDisplay(true)
end

function Hide()
    _root:SetDisplay(false)
end