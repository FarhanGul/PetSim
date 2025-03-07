--!Type(Client)
local audio = require("AudioManager")

function self:Awake()
    for i=0,self.transform.childCount - 1 do
        local child = self.transform:GetChild(i):GetComponent(AudioSource)
        audio.Sources[child.name] = child
    end
end