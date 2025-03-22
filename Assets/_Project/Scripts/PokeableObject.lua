--!Type(Client)
local events = require("EventManager")
local save = require("SaveManager")

local animator : Animator
local tapHandler : TapHandler
local collider : Collider

function self:Awake()
    animator = self.gameObject:GetComponent(Animator)
    tapHandler = self.gameObject:GetComponent(TapHandler)
    collider = self.gameObject:GetComponent(Collider)
    tapHandler.Tapped:Connect(function() 
        if(save.canPoke) then
            animator:SetBool("Discovered",true)
            save.AddDiscoveredAnimation(self.name)
            Destroy()
        end
    end)
    events.SubscribeEvent(events.lateGameStart,function(args)
        if(animator:GetBool("Discovered")) then
            Destroy()
        end
    end)
end

function Destroy()
    Component.Destroy(tapHandler)
    Component.Destroy(collider)
end