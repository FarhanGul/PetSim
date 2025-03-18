--!Type(UI)
local events = require("EventManager")
local data = require("GameData")
local save = require("SaveManager")
local helper = require("Helper")

--!Bind
local _root : VisualElement = nil
--!Bind
local _hintButton : UIButton = nil

function self:Awake()
    _hintButton:RegisterPressCallback(function()
        DisplayHint()
    end)
    events.SubscribeEvent(events.objectiveCompleted,DisplayHint)
    -- events.SubscribeEvent(events.localPlayerTeleported,DisplayHint)
end

function Hide()
    _root:SetDisplay(false)
end

function DisplayHint()
    print("Display Hint")
    if(save.currentObjective == nil) then
        Hide()
    else
        local hint = helper.GetValue(data.objectives,save.currentObjective).text
        Chat:DisplayChatBubble(client.localPlayer.character.chatBubbleTransform,hint,"You")
    end
end