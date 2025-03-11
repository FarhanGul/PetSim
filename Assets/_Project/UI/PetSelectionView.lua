--!Type(UI)
local events = require("EventManager")
local data = require("GameData")

--!Bind
local _root : VisualElement = nil
--!Bind
local _leftButton : UIButton = nil
--!Bind
local _rightButton : UIButton = nil
--!Bind
local _equipButton : UIButton = nil
--!Bind
local _scollProgress : Label = nil

local onLeft
local onRight

function self:Start()
    events.InvokeEvent(events.registerPetSelectionView,self)
    _leftButton:RegisterPressCallback(function() 
        onLeft() 
    end)
    _rightButton:RegisterPressCallback(function() 
        onRight() 
    end)
    Hide()
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