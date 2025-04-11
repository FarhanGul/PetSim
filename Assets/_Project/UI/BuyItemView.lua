--!Type(UI)
local events = require("EventManager")
local data = require("GameData")
local audio = require("AudioManager")

--!Bind
local _root : VisualElement = nil
--!Bind
local _buyButton : UIButton = nil
--!Bind
local _icon : VisualElement = nil
--!Bind
local _cost : Label = nil
--!Bind
local _title : Label = nil
--!Bind
local _description : Label = nil

local onBuy
local canBuy = false

function self:Awake()
    _buyButton:RegisterPressCallback(function() 
        if (canBuy) then 
            audio.Play("Tap")
            onBuy() 
        end 
    end)
    events.SubscribeEvent(events.gameStart,function(args)
        events.InvokeEvent(events.registerBuyItemView,self)
        Hide()
    end)
end

function Show(data,isBuyable,onBuyCallback)
    canBuy = isBuyable
    _cost.text = data.cost
    _title.text = data.title
    _buyButton.style.opacity = StyleFloat.new(isBuyable and 1 or 0.5)
    onBuy = onBuyCallback
    _root:SetDisplay(true)
    events.InvokeEvent(events.bottomUISpaceUpdated,true)
end

function Hide()
    _root:SetDisplay(false)
    events.InvokeEvent(events.bottomUISpaceUpdated,false)
end

function IsDisplayed()
    return _root:IsDisplayed()
end
