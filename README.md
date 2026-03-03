# 🐺 LXR-Stable — Horse Purchasing & Management System

> **wolves.land** | The Land of Wolves | iBoss21 / The Lux Empire

---

```
██╗     ██╗  ██╗██████╗        ███████╗████████╗ █████╗ ██████╗ ██╗     ███████╗
██║     ╚██╗██╔╝██╔══██╗       ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██║     ██╔════╝
██║      ╚███╔╝ ██████╔╝█████╗ ███████╗   ██║   ███████║██████╔╝██║     █████╗  
██║      ██╔██╗ ██╔══██╗╚════╝ ╚════██║   ██║   ██╔══██║██╔══██╗██║     ██╔══╝  
███████╗██╔╝ ██╗██║  ██║       ███████║   ██║   ██║  ██║██████╔╝███████╗███████╗
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝
```

═══════════════════════════════════════════════════════════════════════════════

**Server:**    The Land of Wolves 🐺  
**Developer:** iBoss21 / The Lux Empire  
**Website:**   https://www.wolves.land  
**Discord:**   https://discord.gg/CrKcWdfd3A  
**Store:**     https://theluxempire.tebex.io

> © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved

═══════════════════════════════════════════════════════════════════════════════

## 📋 Framework Support

| Framework    | Status     | Priority |
|-------------|------------|----------|
| LXR-Core    | ✅ Primary  | 1        |
| RSG-Core    | ✅ Primary  | 2        |
| VORP Core   | ✅ Supported| 3        |
| Standalone  | ✅ Fallback | 4        |

---

## 📥 Installation

1. Copy the `lxr-stable` folder into your `[lxr]` resource directory.
2. Execute `lxr-stable.sql` to create the required database tables.
3. Set `Config.Framework` in `config.lua` to match your server framework:
   - `'lxr-core'` — LXR-Core (default)
   - `'rsg-core'` — RSG-Core
   - `'vorp_core'` — VORP Core
   - `'standalone'` — No economy checks
4. Add `ensure lxr-stable` to your `server.cfg`.

---

## ⚙️ Configuration

Edit `config.lua` to customise the stable experience:

- **`Config.Framework`** — Set your server framework.
- **`Config.MaxNumberOfHorses`** — Maximum horses a player can own (default: `3`).
- **`Config.Stables`** — Stable locations, map positions, spawn points, and camera offsets.
- **`Config.Horses`** — Available horse breeds, colour variants, and prices.

### Example — Adding a Stable Location

```lua
Config.Stables = {
    Valentine = {
        Pos = vector3(-367.73, 787.72, 116.26),
        Name = 'Stable Valentine',
        Heading = -30.65,
        SpawnPoint = {
            Pos     = vector3(-372.43, 791.79, 116.13),
            CamPos  = { x = 1, y = -3, z = 0 },
            Heading = 182.3
        }
    },
    -- Add more stables here
}
```

### Example — Adding a Horse Breed

```lua
Config.Horses = {
    { name = "Arabian",
        ["A_C_Horse_Arabian_White"]      = { "White",        1500, 1500 },
        ["A_C_Horse_Arabian_Black"]      = { "Black",        1250, 1250 },
        ["A_C_Horse_Arabian_Grey"]       = { "Grey",         1150, 1150 },
        ["A_C_Horse_Arabian_RedChestnut"]= { "Red Chestnut",  350,  350 },
    },
    -- Add more breeds here
}
```

Full list of available horse models: [RDR2 Horse Models](https://www.rdr2mods.com/wiki/ped-search/?s=horse&pedtype=1&&withComments=1&withDescription=1)

---

## 📋 Dependencies

| Dependency | Purpose |
|-----------|---------|
| `lxr-core` / `rsg-core` / `vorp_core` | Player framework |
| `oxmysql` | Database queries |

---

## 🗄️ Database

The resource will automatically create the `horses` table on first start:

```sql
CREATE TABLE IF NOT EXISTS `horses` (
    `id`         int(11)       NOT NULL AUTO_INCREMENT,
    `cid`        varchar(50)   NOT NULL,
    `selected`   int(11)       NOT NULL DEFAULT 0,
    `model`      varchar(50)   NOT NULL,
    `name`       varchar(50)   NOT NULL,
    `components` varchar(5000) NOT NULL DEFAULT '{}',
    PRIMARY KEY (`id`)
);
```

---

## 🛠️ Features

- 🐎 Full horse purchasing UI with breed and colour selection
- 🎨 Horse customisation — saddles, saddlecloths, stirrups, bags, manes, tails, horns, luggage
- 📍 Multiple stable locations across the map
- 🔔 Whistle to call your horse (`H` key)
- 💾 Persistent horse data stored per character
- 🌐 Multi-framework support (LXR-Core / RSG-Core / VORP / Standalone)
- 🔒 Resource name protection guard

---

## 🔗 Credits

- Original base script: [Luminous-Roleplay LRP_Stable](https://github.com/Luminous-Roleplay/LRP_Stable)
- Refactored & rebranded for **wolves.land** by **iBoss21 / The Lux Empire**

---

*🐺 LXR-Stable — Bringing authentic Western horse management to your RedM server.*
