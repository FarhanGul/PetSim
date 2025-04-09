--!Type(Module)
Sources = {}

--!SerializeField
local audioRoot : Transform = nil

--!SerializeField
local ambience : AudioShader = nil

function self:ClientAwake()
    for i=0,audioRoot.childCount - 1 do
        local child = audioRoot:GetChild(i):GetComponent(AudioSource)
        Sources[child.name] = child
    end
    Audio:PlayMusic(ambience,1)
end

function PlayRandom(names)
    local source : AudioSource = Sources[names[math.random(1,#names)]]
    source:Play()
end

function Play(name)
    local source : AudioSource = Sources[name]
    source:Play()
end
    
function Stop(name)
    local source : AudioSource = Sources[name]
    source:Stop()
end

