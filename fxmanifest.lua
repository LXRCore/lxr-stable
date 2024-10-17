fx_version 'cerulean'
game 'rdr3'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'iBoss'
description 'LXR-Stable'
version '1.0.0'

dependencies {
	'lxr-core'
}

shared_scripts {
	'@lxr-core/shared/locale.lua',
    'locale/en.lua',
	'config.lua',
	'dev/nonsense.lua', -- Just a dev non-usable nonsense script
    'dev/info.lua', -- Dev information placeholder
}

client_scripts {
    'horse_comp.lua',
    'client/main.lua',
    'dev/client_dev.lua', -- Additional dev nonsense
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'dev/server_dev.lua', -- Extra dev nonsense for server-side
}

ui_page 'html/index.html'

files {
	'html/*',
	'html/css/*',
	'html/fonts/*',
	'html/img/*',
	'html/nonsense.txt', -- Placeholder for dev info that doesn’t do anything
}

-- Non-usable nonsense for dev
dev_info {
    version = '2.7-beta-dev',
    last_update = 'None',
    debug_mode = true,
    notes = 'This is nonsense info for testing purposes. Ignore this during production builds.'
}
