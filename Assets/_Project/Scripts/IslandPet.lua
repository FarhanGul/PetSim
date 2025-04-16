--!Type(Client)
local events = require("EventManager")
local save = require("SaveManager")
local data = require("GameData")

--!SerializeField
local animator : Animator = nil
--!SerializeField
local models : {GameObject} = {}

local followDistance = 3; 
local followPlayer = true
local stoppingDistance = nil
local moveToTarget = nil
local onReachedTarget = nil
local previousEvolutionStage = nil
local target : Transform = nil
local isRemotePet = false
local staticRemoteXp

function self:OnDestroy()
    if(not isRemotePet) then
        events.UnsubscribeEvent(events.petXpUpdated,SetModel)
        events.UnsubscribeEvent(events.petTargetUpdated,HandlePetTargetUpdated)
    end
end

function HandlePetTargetUpdated(args)
    if(args[1] ~= nil)then
        followPlayer = args[1];
    end
end

function self:Update()
    if ( target == nil ) then return end

    if(followPlayer)then
        moveToTarget = nil
        local distance = Vector3.Distance(self.transform.position, target.position);
        if (distance > followDistance) then
            animator:SetBool("Run",true)
            self.transform.position = Vector3.Lerp(self.transform.position, target.position, data.speeds.pet * Time.deltaTime / distance);
        else
            animator:SetBool("Run",false)
        end
        self.transform:LookAt(target.position)
    elseif(moveToTarget ~= nil) then
        local targetPos : Vector3 = moveToTarget.position
        targetPos.y = self.transform.position.y
        local distance = Vector3.Distance(targetPos, self.transform.position);
        if (distance > stoppingDistance) then
            animator:SetBool("Run",true)
            self.transform.position = Vector3.Lerp(self.transform.position, targetPos, data.speeds.pet * Time.deltaTime / distance)
            self.transform:LookAt(targetPos)
        else
            animator:SetBool("Run",false)
            moveToTarget = nil
            onReachedTarget()
        end
        self.transform:LookAt(targetPos)
    end
end

function SetModel()    
    local xp
    if(isRemotePet) then
        xp = staticRemoteXp
    else
        xp = save.pets[save.equippedPet].xp
    end
    
    -- Determine evolution stage
    local evolutionStage = 1
    for i = 1, #data.evolutionXp do
        if xp >= data.evolutionXp[i] then
            evolutionStage = i
        end
    end
    
    -- Check for evolution
    if previousEvolutionStage ~= nil and evolutionStage > previousEvolutionStage then
        -- Pet evolved! Add effects here
    end
    
    -- Update model
    for i = 1, #models do
        models[i]:SetActive(i == evolutionStage)
    end
    
    previousEvolutionStage = evolutionStage
end

function MoveTo(_target,_stoppingDistance,onReachedTargetCallback)
    stoppingDistance = _stoppingDistance
    events.InvokeEvent(events.petTargetUpdated)
    followPlayer = false
    moveToTarget = _target
    onReachedTarget = onReachedTargetCallback
end

function GetAnimator()
    return animator
end

function Initialize(_target,_staticXp)
    target = _target
    if(_staticXp ~= nil) then
        isRemotePet = true
        staticRemoteXp = _staticXp
    end
    if(not isRemotePet) then
        events.SubscribeEvent(events.petXpUpdated,SetModel)
        events.SubscribeEvent(events.petTargetUpdated,HandlePetTargetUpdated)
    end
    SetModel()
end