--!Type(Module)

objectives = {
    { key = "introDialogue", text = "Talk to the island resident" },
    { key = "firstEgg", text = "Find the hidden egg" },
    { key = "firstFeed", text = "Your pet is hungry, find some food" },
    { key = "firstPlay", text = "Your pet is now full and wants to play" },
    { key = "evolvePet", text = "Take care of Axolotl until it can be on its own" },
    { key = "petJournal", text = "Talk to max" },
}

cost = {
    egg = 2000,
    petFood = 50,
    playSimonSays = 10
}

petXpProgression = { 99, 299, 799 }

intervals = {
    timeUntilNextChat = 4
}

firstfeedObjectiveXpRequirement = 16

speeds = {
    pet = 5
}

foods = {
    turnip = {
        name = "Turnip",
        timeRequiredToConsume = 4000,
        xpGained = 8,
        rarity = "Common"
    },
    redMushroom = {
        name = "Red Mushroom",
        timeRequiredToConsume = 4,
        xpGained = 12,
        rarity = "Rare"
    }
}

debug = {
    skipDialogue = true
}