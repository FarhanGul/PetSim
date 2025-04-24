--!Type(UI)
local events = require("EventManager")
local data = require("GameData")

--!SerializeField
local backgroundColor : Color = Color.black

--!SerializeField
local npcTitle : string = ""

--!Bind
local _root : VisualElement = nil

--!Bind
local _npcTitle : Label = nil

local cam;

function self:Awake()
    cam = Camera.main.transform
    _npcTitle.text = npcTitle
    _root.style.backgroundColor = StyleColor.new(backgroundColor);
end

function self:Update()
    -- Get the direction from this object to the camera
    local lookPos = cam.position - self.gameObject.transform.position

    -- Keep the rotation only on the Y axis (ignore vertical difference)
    lookPos.y = 0

    -- Prevent LookRotation from failing if the direction is zero
    if lookPos == Vector3.zero then return end

    -- Calculate the base rotation needed to look in that direction
    local baseRotation = Quaternion.LookRotation(lookPos)

    -- Create the offset rotation around the Y axis
    local offsetRotation = Quaternion.Euler(0, 180, 0)

    -- Combine the base rotation and the offset rotation
    local finalRotation = baseRotation * offsetRotation

    -- Apply the final rotation to this GameObject's transform
    self.gameObject.transform.rotation = finalRotation
end