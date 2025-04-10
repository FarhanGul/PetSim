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
local _scollProgress : Label = nil

local onLeft
local onRight

function self:Awake()
    _leftButton:RegisterPressCallback(function() 
        audio.Play("Tap")
        onLeft() 
    end)
    _rightButton:RegisterPressCallback(function() 
        audio.Play("Tap")
        onRight() 
    end)
    events.SubscribeEvent(events.gameStart,function(args)
        events.InvokeEvent(events.registerPetSelectionView,self)
        Hide()
    end)
end

function Show(onLeftCallback,onRightCallback)
    onLeft = onLeftCallback
    onRight = onRightCallback
    _root:SetDisplay(true)
end

function Hide()
    _root:SetDisplay(false)
end

function IsDisplayed()
    return _root:IsDisplayed()
end

function UpdateScrollProgressText(current,total)
    _scollProgress.text = current.." / "..total
end