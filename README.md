# 🐎 LXR-Stables
Horse Purchasing System for LXRCore

---

## 📥 Installation:

1. Copy the `lxr-stables` folder into your `[lxr]` directory.
2. Execute the SQL file to add necessary tables to your database.

---

## ⚙️ Configuration:

- You can customize and add more horses in the `config.lua`.
- The configuration includes various stables and horses with customizable prices, names, and spawn points.
  
- List of horses available for addition can be found here: [RDR2 Horse Models](https://www.rdr2mods.com/wiki/ped-search/?s=horse&pedtype=1&&withComments=1&withDescription=1)

### Sample Configuration:

```lua
Config = {}

-- Max number of horses a player can own
Config.MaxNumberOfHorses = 3

-- Stable locations and details
Config.Stables = {
    Valentine   = { Pos = vector3(-367.73, 787.72, 116.26), Name = 'Stable Valentine',    Heading = -30.65, SpawnPoint = { Pos = vector3(-372.43, 791.79, 116.13), CamPos = {x=1, y=-3, z=0}, Heading = 182.3 }},
    Blackwater  = { Pos = vector3(-864.84, -1365.96, 43.54), Name = 'Stable Blackwater',  Heading = -30.65, SpawnPoint = { Pos = vector3(-867.74, -1361.69, 43.66), CamPos = {x=1, y=-3, z=0}, Heading = 178.59 }},
    SaintDenis  = { Pos = vector3(2503.13, -1449.08, 46.3),  Name = 'Stable Saint Denis', Heading = -30.65, SpawnPoint = { Pos = vector3(2508.41, -1446.89, 46.4),  CamPos = {x=1, y=-3, z=0}, Heading = 87.88 }},
    Annesburg   = { Pos = vector3(2972.35, 1425.35, 44.67),  Name = 'Stable Annesburg',   Heading = -30.65, SpawnPoint = { Pos = vector3(2970.43, 1429.35, 44.7),  CamPos = {x=1, y=-3, z=0}, Heading = 223.94 }},
    Rhodes      = { Pos = vector3(1321.46, -1358.66, 78.39), Name = 'Stable Rhodes',      Heading = -30.65, SpawnPoint = { Pos = vector3(1318.74, -1354.64, 78.18), CamPos = {x=1, y=-3, z=0}, Heading = 249.45 }},
    Tumbleweed  = { Pos = vector3(-5519.43, -3043.45, -2.39), Name = 'Stable Tumbleweed', Heading = 0.0,    SpawnPoint = { Pos = vector3(-5522.14, -3039.16, -2.29), CamPos = {x=1, y=-3, z=0}, Heading = 189.93 }},
}

-- Available horses and prices
Config.Horses = {
    { name = "Arabian", 
        ["A_C_Horse_Arabian_White"] = {"White", 1500, 1500}, ["A_C_Horse_Arabian_RoseGreyBay"] = {"Rose Grey Bay", 1350, 12350}, 
        ["A_C_Horse_Arabian_Black"] = {"Black", 1250, 1250}, ["A_C_Horse_Arabian_Grey"] = {"Grey", 1150, 1150}
    },
    { name = "Ardennes", 
        ["A_C_Horse_Ardennes_IronGreyRoan"] = {"Iron Grey Roan", 1200, 1200}, ["A_C_Horse_Ardennes_StrawberryRoan"] = {"Strawberry Roan", 450, 450}
    },
    -- Add more breeds and horses as per your needs
}
```

You can adjust prices, locations, and more directly from the `config.lua` to suit your server's gameplay experience.

---

## 📋 Dependencies

- **LXRCore Framework**
- **MySQL** (for database support)

---

## 🔗 Credits:

- Original base script: [Luminous-Roleplay LRP_Stable](https://github.com/Luminous-Roleplay/LRP_Stable)

---

## 🛠️ Customization and Features:

- Customize horse breeds, stable locations, and spawn points.
- Expand or modify the list of horses available for purchase.
- Modify stable spawn points and add camera positions for a dynamic experience.

---

**LXR-Stables** brings horse purchasing and management into your LXRCore-powered RedM server with ease. Modify and configure as needed! 

---