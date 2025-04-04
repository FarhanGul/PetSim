--!Type(Module)

-- Static
objectives = {
    { key = "introDialogue", text = "I should go talk to the island resident, he would know where all the exotic creatures are" },
    { key = "firstEgg", text = "The caretaker said the egg is hidden behind one of these rocks" },
    { key = "firstFeed", text = "Axolotl is hungry, I should get it something to eat" },
    { key = "firstPlay", text = "Axolotl looks bored, I better find something it can play with" },
    { key = "talkToCartographer", text = "I need some way to get to the other islands so I can save more pets" },
    { key = "buyFirstMap", text = "I need that map so I can head over to the other island" },
    { key = "getBackToTheBoat", text = "Now that I have the map, I should head to the boat" },
    { key = "secondEgg", text = "I wonder if there are more hidden eggs" },
    { key = "findAboutPresence", text = "I should find out what this mysterious presence is, that everyone keeps talking about" },
}

locations = {
    Day1 = {
        title = "Jungle",
        iconClass = "island-01"
    },
    Day2 = {
        title = "Crystal",
        iconClass = "island-02"
    }
}

totalDays = 2

buyableItems = {
    day2Map = {
        cost = 300,
        title = "Crystal Reef"
    }
}

petXpProgression = { 5, 25, 75, 225, 625, 1625, 3625, 7625, 15625, 30625, 65625, 140625, 240625 }

currencyRewardForLevelUp = { 4 , 5, 6, 10 , 25 , 50 , 100 , 200 , 400 , 600 , 800 , 1600 , 2000 }

intervals = {
    timeUntilNextChat = 4
}

speeds = {
    pet = 5
}

totalPets = 1

foods = {
    turnip = {
        name = "Turnip",
        timeRequiredToConsume = 8,
        xpGained = 8,
        rarity = "Common"
    },
    carrot = {
        name = "Carrot",
        timeRequiredToConsume = 6,
        xpGained = 32,
        rarity = "Uncommon"
    },
    mushroom = {
        name = "Red Mushroom",
        timeRequiredToConsume = 4,
        xpGained = 128,
        rarity = "Rare"
    },
}

foodRegnerationWait = {
    min = 60,
    max = 120
}

rarityWeights = {
    -- Must add up to 100
    Common = 60,    
    Uncommon = 30,  
    Rare = 10
}

simonSays = {
    title = "Petal Pulse",
    description = "Watch carefully as the plant's bioluminescent petals light up in a sequence. Your task is to repeat the pattern exactly as shown"
}

debug = {
    skipDialogue = false
}

-- Varaibles
totalDiscoveries = 0