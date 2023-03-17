fx_version 'cerulean'
games { 'gta5' }
author 'Fly Development'


server_scripts {
     '@mysql-async/lib/MySQL.lua',
     'server.lua',
     'bot.js'
} 
client_scripts {
     'client.lua',
     'Config.lua'
}
