--!Type(UI)
local events = require("EventManager")
local save = require("SaveManager")
local data = require("GameData")
local helper = require("Helper")

--!Bind
local _coins : Label = nil

function self:Awake()
    events.SubscribeEvent(events.gameStart,Update)
    events.SubscribeEvent(events.coinsUpdated,Update)
end

function Update()
    _coins.text = save.coins
end