--!Type(Module)

objectives = {
    { key = "introDialogue", text = "I should go talk to the island resident, he would know where all the exotic creatures are" },
    { key = "firstEgg", text = "Max said the egg is hidden behind one of these rocks" },
    { key = "firstFeed", text = "Axolotl is hungry, I should feed it some plants" },
    { key = "firstPlay", text = "Axolotl looks bored, I better find something it can play with" },
    { key = "completeDay1", text = "I should explore what other treats and toys the island has to offer" },
    { key = "sleepDay1", text = "That was a long day, I'll should head off to sleep now" },
    { key = "Day2StartDialogue", text = "Maybe max knows what is going on" },
}

totalDays = 2

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

totalPets = 3

discoveries = {
    starter = 6,
}

foods = {
    turnip = {
        name = "Turnip",
        timeRequiredToConsume = 8,
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
    skipDialogue = false
}