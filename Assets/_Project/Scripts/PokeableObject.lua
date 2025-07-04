--!Type(Client)
local events = require("EventManager")
local save = require("SaveManager")
local audio = require("AudioManager")

--!SerializeField
local soundName : string = ""

local animator : Animator
local tapHandler : TapHandler
local collider : Collider

function self:Awake()
    animator = self.gameObject:GetComponent(Animator)
    tapHandler = self.gameObject:GetComponent(TapHandler)
    collider = self.gameObject:GetComponent(Collider)
    tapHandler.Tapped:Connect(function() 
        if(soundName ~= "")then
            audio.Play(soundName)
        end
        animator:SetBool("Discovered",true)
        save.AddDiscoveredAnimation(self.name)
        Destroy()
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