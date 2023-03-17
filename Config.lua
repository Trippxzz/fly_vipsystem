Config = {}

Config.Vips = {         --##if you add more types of vips or change their values, remember to change them in bot.js (line 100) as well.
     {
        Icon = "🟫",
        Name = "Bronze",
        Ped = 'notavailable',
        Cars = 1,   
        Money = 1000
    },
     {
        Icon = "⬜",
        Name = "Silver",
        Ped = 'notavailable',
        Cars = 2,
        Money = 2000
    },
     {
        Icon = "🟨",
        Name = "Golden",
        Ped = 1,           --if it is a 1, it can have 1 ped
        Cars = 3,
        Money = 3000
    },
    {
        Icon = "🟦",
        Name = "Diamond",
        Ped = 1,
        Cars = 5,           --number of cars you can claim
        Money = 4000
    }
}

Config.Cars = {
     {model = "t20", label = "T20" ,category = "Bronze"},
     {model = "komoda", label = "Komoda", category = "Bronze"},
     {model ="zentorno", label = "Zentorno", category ="Silver"},
     {model = "adder", label = "Adder", category ="Silver"},
     {model = "krieger", label = "Krieger", category = "Golden"},
     {model = "xa21", label = "Xa-21", category = "Golden"},
     {model = "toros", label = "Toros", category ="Diamond"},
     {model = "vacca", label = "Vaca", category ="Diamond"}
    
}