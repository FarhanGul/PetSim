--!Type(Module)
Sources = {}

function PlayRandom(names)
    local source : AudioSource = Sources[names[math.random(1,#names)]]
    source:Play()
end

function Play(name)
    local source : AudioSource = Sources[name]
    source:Play()
end