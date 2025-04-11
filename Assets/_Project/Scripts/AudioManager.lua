--!Type(Module)
Sources = {}

--!SerializeField
local audioRoot : Transform = nil

function self:ClientAwake()
    for i=0,audioRoot.childCount - 1 do
        local child = audioRoot:GetChild(i):GetComponent(AudioSource)
        Sources[child.name] = child
    end
end

function PlayRandom(names)
    local source : AudioSource = Sources[names[math.random(1,#names)]]
    source:Play()
end

function Play(name)
    local source : AudioSource = Sources[name]
    source:Play()
end

function PlayOneShot(name)
    local source : AudioSource = Sources[name]
    source:PlayOneShot(source.clip)
end
    
function Stop(name)
    local source : AudioSource = Sources[name]
    source:Stop()
end

