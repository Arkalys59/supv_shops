fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'SUP2Ak'
version '1.0'
link 'https://github.com/SUP2Ak/supv_shops'
description 'supv_shops (example to use module from supv_core)'

shared_scripts { 
	'@es_extended/imports.lua',
	'@supv_core/import.lua',
	'_g.lua',
	'config/shared.lua'
}

client_scripts {
	"src/RMenu.lua",
	"src/m/RageUI.lua",
	"src/m/Menu.lua",
	"src/m/MenuController.lua",
	"src/c/*.lua",
	"src/m/elements/*.lua",
	"src/m/items/*.lua",
	"src/m/panels/*.lua",
	"src/m/windows/*.lua",
}

client_scripts {
	'config/client.lua',
	'client/*.lua'
}

server_scripts {
    --'@oxmysql/lib/MySQL.lua',
	'config/server.lua',
	'server/*.lua'
}

depandencies {
    'es_extended',
    'supv_core',
}