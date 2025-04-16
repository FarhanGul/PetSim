--!Type(Client)
local events = require("EventManager")
local save = require("SaveManager")
local data = require("GameData")

--!SerializeField
local models : {GameObject} = {}

local followDistance = 3; 
local followPlayer
local stoppingDistance = nil
local moveToTarget = nil
local onReachedTarget = nil
local animator : Animator = nil
local previousEvolutionStage = nil
local target : Transform = nil

function self:Awake()
    animator = self:GetComponent(Animator)
    events.SubscribeEvent(events.petXpUpdated,SetModel)
    events.SubscribeEvent(events.petTargetUpdated,HandlePetTargetUpdated)
    SetModel()
end

function self:OnDestroy()
    events.UnsubscribeEvent(events.petXpUpdated,SetModel)
    events.UnsubscribeEvent(events.petTargetUpdated,HandlePetTargetUpdated)
end

function HandlePetTargetUpdated(args)
    if(args[1] ~= nil)then
        followPlayer = args[1];
    end
end

function self:Start()
    events.InvokeEvent(events.petTargetUpdated,true)
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
    local currentPet = save.pets[save.equippedPet]
    
    -- Determine evolution stage
    local evolutionStage = 1
    for i = 1, #data.evolutionXp do
        if currentPet.xp >= data.evolutionXp[i] then
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

function SetTarget(_target)
    target = _target
end