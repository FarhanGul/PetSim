--!Type(Module)

objectives = {
    { key = "introDialogue", text = "Talk to the island resident" },
    { key = "firstEgg", text = "Find the hidden egg" },
    { key = "firstFeed", text = "Your pet is hungry, feed it some turnips" },
    { key = "firstPlay", text = "Your pet is now full and wants to play" },
    { key = "petJournal", text = "Complete your pet journal" },
    { key = "evolvePet", text = "Evolve pets to access new areas" }
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
        canBeEatenForSeconds = 16,
        xpPerSecond = 1,
        growthWaitSeconds = 30,
    },
    redMushroom = {
        name = "Red Mushroom",
        canBeEatenForSeconds = 8,
        xpPerSecond = 2,
        growthWaitSeconds = 60,
    }
}

debug = {
    skipDialogue = false
}