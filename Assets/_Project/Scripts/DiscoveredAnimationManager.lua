--!Type(Client)
local events = require("EventManager")
local save = require("SaveManager")

function self:Awake()
    events.SubscribeEvent(events.gameStart,function(args)
        Initialize()
    end)
end

function Initialize()
    for i = 1, #save.discoveredAnimationIds do
        self.transform:Find(save.discoveredAnimationIds[i]):GetComponent(Animator):SetBool("Override",true)
    end
end