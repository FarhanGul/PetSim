--!Type(UI)
local xpSystem = require("XpSystem")
local events = require("EventManager")
local save = require("SaveManager")
local helper = require("Helper")

--!Bind
local _root : VisualElement = nil
--!Bind
local _nameLabel : Label = nil
--!Bind
local _followPlayerButton : UIButton = nil
--!Bind
local _petSwitchButton : UIButton = nil
--!Bind
local _xpRequiredLabel : Label = nil
--!Bind
local _xpDescriptionLabel : Label = nil
--!Bind
local _xpFill : VisualElement = nil
--!Bind
local _ageLabel : Label = nil

local xpView
local isPetFollowingPlayer
local petSelectionView

function self:Awake()
    xpView = xpSystem.new(_xpFill,_xpRequiredLabel,_xpDescriptionLabel,_ageLabel)
    _petSwitchButton:RegisterPressCallback(function()
        events.InvokeEvent(events.petSwitcherOpened)
    end)
    _followPlayerButton:RegisterPressCallback(function()
        events.InvokeEvent(events.petTargetUpdated,true)
    end)
    events.SubscribeEvent(events.petXpUpdated,function(args)
        SetXp(save.pets[save.equippedPet].xp)
    end)
    events.SubscribeEvent(events.petSpawned,function(args)
        _root.style.display = DisplayStyle.Flex
        SetName(save.equippedPet)
        local petData = save.pets[save.equippedPet]
        SetXp(petData.xp)
    end)
    events.SubscribeEvent(events.petTargetUpdated,function(args)
        isPetFollowingPlayer = args[1] ~= nil
        SetDynamicButtonState()
    end)
    events.SubscribeEvent(events.registerPetSelectionView,function(args)
        petSelectionView = args[1]
    end)
    events.SubscribeEvent(events.gameStart,function(args)
        _root.style.display = (save.equippedPet == nil) and DisplayStyle.None or DisplayStyle.Flex
    end)
end

function self:Update()
    if(petSelectionView.IsDisplayed() and client.localPlayer.character.isMoving)then
        petSelectionView.Hide()
        SetDynamicButtonState()
        events.InvokeEvent(events.saveGame)
    end
end

function SetName(name)
    _nameLabel.text = name
end

function SetXp(xp)
    xpView.Update(xp)
end

function SetDynamicButtonState()
    _petSwitchButton.style.display = ((not petSelectionView.IsDisplayed()) and isPetFollowingPlayer and helper.GetTableLength(save.pets) >= 2 ) and DisplayStyle.Flex or DisplayStyle.None
end