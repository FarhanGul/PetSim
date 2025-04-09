--!Type(UI)
local events = require("EventManager")
local data = require("GameData")
local audio = require("AudioManager")

--!Bind
local _root : VisualElement = nil
--!Bind
local _playButton : UIButton = nil
--!Bind
local _helpButton : UIButton = nil

local onPlay
local onHelp

function self:Awake()
    _playButton:RegisterPressCallback(function() 
        audio.Play("Tap")
        onPlay() 
    end)
    _helpButton:RegisterPressCallback(function()
         onHelp() 
    end)
    events.SubscribeEvent(events.gameStart,function(args)
        events.InvokeEvent(events.registerReadyToPlayView,self)
        Hide()
    end)
end

function Show(onPlayCallback,onHelpCallback)
    onPlay = onPlayCallback
    onHelp = onHelpCallback
    _root:SetDisplay(true)
end

function Hide()
    _root:SetDisplay(false)
end