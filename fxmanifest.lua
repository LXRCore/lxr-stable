--[[
    ██╗     ██╗  ██╗██████╗        ███████╗████████╗ █████╗ ██████╗ ██╗     ███████╗
    ██║     ╚██╗██╔╝██╔══██╗       ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██║     ██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗ ███████╗   ██║   ███████║██████╔╝██║     █████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝ ╚════██║   ██║   ██╔══██║██╔══██╗██║     ██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║       ███████║   ██║   ██║  ██║██████╔╝███████╗███████╗
    ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝

    🐺 LXR Stable — Horse Purchasing & Management System

    ═══════════════════════════════════════════════════════════════════════════════
    SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════

    Server:    The Land of Wolves 🐺
    Developer: iBoss21 / The Lux Empire
    Website:   https://www.wolves.land
    Discord:   https://discord.gg/CrKcWdfd3A
    Store:     https://theluxempire.tebex.io

    ═══════════════════════════════════════════════════════════════════════════════

    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

fx_version 'cerulean'
game 'rdr3'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

name        'lxr-stable'
author      'iBoss21 / The Lux Empire'
description '🐺 LXR Stable — Horse Purchasing & Management System | wolves.land'
version     '1.0.0'

dependencies {
    'lxr-core',
}

shared_scripts {
    '@lxr-core/shared/locale.lua',
    'locale/en.lua',
    'config.lua',
}

client_scripts {
    'horse_comp.lua',
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

ui_page 'html/index.html'

files {
    'html/*',
    'html/fonts/*',
    'html/img/*',
}
