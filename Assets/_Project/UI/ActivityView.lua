--!Type(UI)
local events = require("EventManager")
local data = require("GameData")

--!Bind
local _root : VisualElement = nil
--!Bind
local _xpLabel : Label = nil
--!Bind
local _xpDescriptionLabel : Label = nil
--!Bind
local _activityName : Label = nil
--!Bind
local _activitySubtitle : Label = nil
--!Bind
local _xpReward : Label = nil
--!Bind
local _xpFill : VisualElement = nil

function self:Awake()
    events.SubscribeEvent(events.gameStart,function(args)
        events.InvokeEvent(events.registerActivityView,self)
        Hide()
    end)
end

function SetProgress(label,pc)
    _xpLabel.text = label
    _xpFill.style.width = StyleLength.new(Length.new(pc * 384))
end

function Show(name,subtitle,xpGained,xpDescription)
    _activityName.text = name
    _activitySubtitle.text = subtitle
    _xpReward.text = xpGained
    _xpDescriptionLabel.text = xpDescription
    _root:SetDisplay(true)
end

function SetProgressDescription(description)
    _xpDescriptionLabel.text = description
end

function SetXpGained(xpGained)
    _xpReward.text = xpGained
end

function Hide()
    _root:SetDisplay(false)
end

function IsDisplayed()
    return _root:IsDisplayed()
end
