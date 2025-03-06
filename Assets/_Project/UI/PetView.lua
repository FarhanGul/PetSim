--!Type(UI)
local xpSystem = require("XpSystem")
local events = require("EventManager")
local save = require("SaveManager")

--!Bind
local _root : VisualElement = nil
--!Bind
local _nameLabel : Label = nil
--!Bind
local _statusLabel : Label = nil
--!Bind
local _statusIcon : VisualElement = nil
--!Bind
local _followPlayerButton : UIButton = nil
--!Bind
local _xpRequiredLabel : Label = nil
--!Bind
local _xpDescriptionLabel : Label = nil
--!Bind
local _xpFill : VisualElement = nil
--!Bind
local _ageLabel : Label = nil

local xpView

function self:Awake()
    xpView = xpSystem.new(_xpFill,_xpRequiredLabel,_xpDescriptionLabel,_ageLabel)
    _followPlayerButton:RegisterPressCallback(function()
        events.InvokeEvent(events.followPlayer)
    end)
    events.SubscribeEvent(events.petXpUpdated,function(args)
        SetXp(save.pets[save.equippedPet].xp)
    end)
    events.SubscribeEvent(events.petSpawned,function(args)
        _root.style.display = DisplayStyle.Flex
        SetName(save.equippedPet)
        local petData = save.pets[save.equippedPet]
        SetStatus(petData.status)
        SetXp(petData.xp)
    end)
    events.SubscribeEvent(events.petStatusUpdated,function(args)
        SetStatus(save.pets[save.equippedPet].status)
    end)
    _root.style.display = DisplayStyle.None
end

function self:Start()
    _root.style.display = (save.equippedPet == nil) and DisplayStyle.None or DisplayStyle.Flex
end

function SetName(name)
    _nameLabel.text = name
end

function SetStatus(status)
    _statusLabel.text = status
    _statusIcon:EnableInClassList("hungry-status", status == "Hungry")
    _statusIcon:EnableInClassList("playful-status", status == "Playful")
end

function SetXp(xp)
    xpView.Update(xp)
end