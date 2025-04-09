--!Type(UI)
local events = require("EventManager")
local data = require("GameData")
local audio = require("AudioManager")

--!Bind
local _root : VisualElement = nil
--!Bind
local _leftButton : UIButton = nil
--!Bind
local _rightButton : UIButton = nil
--!Bind
local _goButton : UIButton = nil
--!Bind
local _locationTitle : Label = nil
--!Bind
local _locationIcon : VisualElement = nil

local onLeft
local onRight
local onGo

function self:Awake()
    _leftButton:RegisterPressCallback(function() 
        audio.Play("Tap")
        onLeft() 
    end)
    _rightButton:RegisterPressCallback(function() 
        audio.Play("Tap")
        onRight() 
    end)
    _goButton:RegisterPressCallback(function() 
        audio.Play("Tap")
        onGo()
    end)
    events.SubscribeEvent(events.gameStart,function(args)
        events.InvokeEvent(events.registerLocationSelectionView,self)
        Hide()
    end)
end

function Show(onLeftCallback,onRightCallback,onGoCallback)
    onLeft = onLeftCallback
    onRight = onRightCallback
    onGo = onGoCallback
    _root:SetDisplay(true)
end

function Hide()
    _root:SetDisplay(false)
end

function SetLocation(locationData,isCurrent)
    _locationTitle.text = locationData.title
    _locationIcon:EnableInClassList("island-01", locationData.iconClass=="island-01")
    _locationIcon:EnableInClassList("island-02", locationData.iconClass=="island-02")
    _goButton:SetDisplay(not isCurrent)
end

function IsDisplayed()
    return _root:IsDisplayed()
end
