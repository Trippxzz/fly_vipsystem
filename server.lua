ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local ident = nil

local webhook = '' --#####PUT YOUR WEBHOOK LINK ######--

exports('GiveVip', function(id, typevip, car, ped, money)
                if GetPlayerName(id) then
                    local xPlayer = ESX.GetPlayerFromId(id)
                    if xPlayer then
                        TriggerEvent('give:vip', id, typevip, car, ped, money)
                    else   
                        print('log')
                    end
                else
                    TriggerEvent('give:vipident', id, typevip, car, ped, money)
                end 
end)

exports('GenerateCode', function(a, typevip, car, ped, money)
    MySQL.Sync.execute('INSERT INTO fly_vip (code, vip ,car, ped, money) VALUES (@code,@vip, @car, @ped, @money)', {
        ['@code'] = a,
        ['@vip'] = typevip,
        ['@car'] = car,
        ['@ped'] = ped,
        ['@money'] = money
    })
end)

exports('SearchVip', function()
    TriggerEvent('fly:searchvip')
end)

exports('SetPed', function(id, haskey)
    if GetPlayerName(id) then
        ident = Identifier(id)
        local xPlayer = ESX.GetPlayerFromId(id)
        if xPlayer then
            TriggerEvent('fly:setped', id, haskey)
        else   
            print('log')
        end
    else
        TriggerEvent('fly:setpedid', id, haskey)   
    end 
end)

exports('Removevip', function(id)
        if GetPlayerName(id) then
            ident = Identifier(id)
            local xPlayer = ESX.GetPlayerFromId(id)
            if xPlayer then
                TriggerEvent('fly:removevip', ident)
            else   
                print('log')
            end
        else
            TriggerEvent('give:removevipident', id)
        end 
end)


RegisterNetEvent('fly:checkid')
AddEventHandler('fly:checkid', function(idplayer)
    local Player = ESX.GetPlayerFromId(source)
    local name = GetPlayerName(idplayer)
    print(idplayer)
        local xPlayer = ESX.GetPlayerFromId(idplayer)
        if xPlayer then
            TriggerClientEvent('fly:confirmid', -1, idplayer, name)
        else   
            idplayer = 'N/A'
            name = 'N/A'
            TriggerClientEvent('fly:confirmid', -1, idplayer, name)
            Player.showNotification("This player is not online")
        end 
end)

RegisterNetEvent('code:generate')
AddEventHandler('code:generate', function(typevip, car, ped, money)
    local xPlayer = ESX.GetPlayerFromId(source)
    a = string.random(13)
    MySQL.Sync.execute('INSERT INTO fly_vip (code, vip ,car, ped, money) VALUES (@code,@vip, @car, @ped, @money)', {
        ['@code'] = a,
        ['@vip'] = typevip,
        ['@car'] = car,
        ['@ped'] = ped,
        ['@money'] = money
    })
    xPlayer.showNotification("You generated a VIP code, check the log channel to see the code generated")
    LogDiscord("License: **"..xPlayer.identifier.."** has generated the code `"..a.."` with category "..typevip.."")
end)

RegisterNetEvent('give:vip')
AddEventHandler('give:vip', function(id, typevip, car, ped, money)
    print(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local PlayerVIP = ESX.GetPlayerFromId(id)
    a = string.random(13)
    ident = Identifier(id)
    local result = MySQL.Sync.fetchAll('SELECT * FROM fly_vip WHERE identifier = @identifier', {['@identifier'] = ident})
    if result[1] == nil then
    MySQL.Sync.execute('INSERT INTO fly_vip (code, identifier, vip ,car, ped, money) VALUES (@code, @identifier,@vip, @car, @ped, @money)', {
        ['@code'] = a,
        ['@identifier'] = ident,
        ['@vip'] = typevip,
        ['@car'] = car,
        ['@ped'] = ped,
        ['@money'] = money
    })
    PlayerVIP.showNotification("You have been granted VIP privilege")
         if xPlayer then
            xPlayer.showNotification("You gave VIP privileges to the player with ID: "..id)
            LogDiscord("License: **"..xPlayer.identifier.."** has given him a vip "..typevip.." to License: **"..PlayerVIP.identifier.."**")
            else
                local embed = {
                    color = "GOLD", 
                    title = 'Success',
                    description = ' You gave VIP privileges to the player with ID: '..ident..'  `'..a..'`'
                }
                TriggerEvent('fly_vipsystem:SendEmbed', embed)
        end
    else
        if xPlayer then
            xPlayer.showNotification("is already vip")
        else
            local embed = {
                color = "RED", 
                title = 'Error',
                description = ' is already vip.'
            }
            TriggerEvent('fly_vipsystem:SendEmbed', embed)
        end
    end
end)

RegisterNetEvent('give:vipident')
AddEventHandler('give:vipident', function(id, typevip, car, ped, money)
    a = string.random(13)
    MySQL.Sync.execute('INSERT INTO fly_vip (code, identifier, vip ,car, ped, money) VALUES (@code, @identifier,@vip, @car, @ped, @money)', {
        ['@code'] = a,
        ['@identifier'] = id,
        ['@vip'] = typevip,
        ['@car'] = car,
        ['@ped'] = ped,
        ['@money'] = money
    })
    local embed = {
        color = "GOLD", 
        title = 'SUCCESS',
        description = ' You gave VIP privileges to the player with ID: '..id.. ' `'..a..'`'
    }
    TriggerEvent('fly_vipsystem:SendEmbed', embed)
end)


RegisterNetEvent('fly:removevip')
AddEventHandler('fly:removevip', function(player)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute("DELETE FROM fly_vip WHERE identifier = @identifier",{['@identifier'] = player}) 
    LogDiscord("License: **"..xPlayer.identifier.."** has removed "..player)
end)

RegisterNetEvent('fly:removevipident')
AddEventHandler('fly:removevipident', function(player)
    MySQL.Async.execute("DELETE FROM fly_vip WHERE identifier = @identifier",{['@identifier'] = player}) 
end)

RegisterNetEvent('fly:redeem')
AddEventHandler('fly:redeem', function(code, source)
    local result = MySQL.Sync.fetchAll('SELECT * FROM fly_vip WHERE code = @code', {['@code'] = code})
    local xPlayer = ESX.GetPlayerFromId(source)
    if result[1] ~= nil then
        local result2 = MySQL.Sync.fetchAll('SELECT * FROM fly_vip WHERE identifier = @identifier AND code = @code', {['@code'] = code, ['@identifier'] = 'notredeem'})
        ident = Identifier(source)
        if result2[1] ~= nil then
        xPlayer.showNotification("Congratulations, you now have access to VIP privileges")
        MySQL.Sync.execute('UPDATE fly_vip SET identifier = @identifier WHERE code = @code', {
            ['@identifier'] = ident,
            ['@code'] = code
        })
        LogDiscord("License: **"..xPlayer.identifier.."** have redeemed a vip code `"..code.."`")
        else
            xPlayer.showNotification("Someone already redeemed this code")
        end
    else
        xPlayer.showNotification("Invalid code")
    end
end)


ESX.RegisterServerCallback("fly:vipplayers", function(source, cb)
	
	local playersvip = {}

	MySQL.Async.fetchAll("SELECT identifier FROM fly_vip WHERE identifier != @identifier", { ["@identifier"] = 'notredeem' }, function(result)

		for i = 1, #result, 1 do
			table.insert(playersvip, {identifier = result[i].identifier })
		end

		cb(playersvip)
	end)
end)

RegisterNetEvent('fly:searchvip')
AddEventHandler('fly:searchvip', function()
    local playersvip = {}

	MySQL.Async.fetchAll("SELECT * FROM fly_vip ", function(result)
        local embed = {
            fields = {},
            color = "#2f3136", -- blue
            title = 'Results',
            description = ''
        }
		for i = 1, #result, 1 do
			table.insert(embed.fields, {name = '`'..result[i].code..'`' , value = result[i].identifier,  inline = true})
		end
        TriggerEvent('fly_vipsystem:SendEmbed', embed)

	end)
end)

RegisterNetEvent('fly:checkvip')
AddEventHandler('fly:checkvip', function(source)
    ident = Identifier(source)
    local xPlayer = ESX.GetPlayerFromId(source)
	local result =  MySQL.Sync.fetchAll('SELECT * FROM fly_vip WHERE identifier = @identifier', {['@identifier'] = ident})
    if result[1] ~= nil then
        TriggerClientEvent('fly:success', -1, result[1].vip, result[1].car, result[1].ped, result[1].money)
    else
        xPlayer.showNotification('You are not vip, but you can buy one in our discord')
    end
end)


RegisterNetEvent('fly:checkped')
AddEventHandler('fly:checkped', function()
    ident = Identifier(source)
	local result =  MySQL.Sync.fetchAll('SELECT ped FROM fly_vip WHERE identifier = @identifier', {['@identifier'] = ident})
    if result[1] ~= nil then
        TriggerClientEvent('fly:spawnped', -1, result[1].ped)
    end
end)

RegisterNetEvent('fly:setped')
AddEventHandler('fly:setped', function(player, haskeyped)
    local xPlayer = ESX.GetPlayerFromId(source)
    local result =  MySQL.Sync.fetchAll('SELECT * FROM fly_vip WHERE identifier = @identifier AND ped != @ped', {['@identifier'] = player, ['@ped'] = 'notavailable'})
    if result[1] ~= nil then
    MySQL.Sync.execute('UPDATE fly_vip SET ped = @ped WHERE identifier = @identifier ', {
        ['@identifier'] = player,
        ['@ped'] = haskeyped,
    })
    xPlayer.showNotification('You have given the ped '..haskeyped..' to the '..ident)
    LogDiscord("License: **"..xPlayer.identifier.."** has given the ped: "..haskeyped.." to player "..player)
    else
        if xPlayer then
        xPlayer.showNotification("Player vip does not allow peds")
        else
            local embed = {
                color = "RED", 
                title = 'Error',
                description = ' Player vip does not allow peds'
            }
            TriggerEvent('fly_vipsystem:SendEmbed', embed)
        end
    end
end)

RegisterNetEvent('fly:setpedid')
AddEventHandler('fly:setpedid', function(player, haskeyped)
    ident = Identifier(player)
    local result =  MySQL.Sync.fetchAll('SELECT * FROM fly_vip WHERE identifier = @identifier AND ped != @notped', {['@identifier'] = ident, ['@notped'] = 'notavailable'})
    if result[1] ~= nil then
    MySQL.Sync.execute('UPDATE fly_vip SET ped = @ped WHERE identifier = @identifier ', {
        ['@identifier'] = ident,
        ['@ped'] = haskeyped,
    })
    local embed = {
        color = "GOLD", 
        title = 'Success',
        description = 'You have given the ped '..haskeyped..' to the '..ident
    }
    TriggerEvent('fly_vipsystem:SendEmbed', embed)
    else
        local embed = {
            color = "RED", 
            title = 'Error',
            description = ' Player vip does not allow peds'
        }
        TriggerEvent('fly_vipsystem:SendEmbed', embed)
    end
end)

RegisterNetEvent('claim:money')
AddEventHandler('claim:money', function()
    ident = Identifier(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local result =  MySQL.Sync.fetchAll('SELECT money FROM fly_vip WHERE identifier = @identifier AND money != 0', {['@identifier'] = ident})
    if result[1] ~= nil then
        xPlayer.addAccountMoney('bank', result[1].money)
        xPlayer.showNotification('You received the $'..result[1].money..' reward for being vip')
        MySQL.Sync.execute('UPDATE fly_vip SET money = 0 WHERE identifier = @identifier', {
            ['@identifier'] = ident
        })
    else
        xPlayer.showNotification('You have already made use of this reward')
    end
end)

RegisterServerEvent('fly:givecar')
AddEventHandler('fly:givecar', function (model, vehicleprops, cars)
	local xPlayer = ESX.GetPlayerFromId(source)
    ident = Identifier(source)
	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, stored, type) VALUES (@owner, @plate, @vehicle, @stored, @type)',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleprops.plate,
		['@vehicle'] = json.encode(vehicleprops),
        ['@type']  = 'car',
		['@stored']  = 1
	}, function ()
        xPlayer.showNotification("You have received your "..model..", enjoy it")
	end)
    MySQL.Sync.execute('UPDATE fly_vip SET car = car - 1 WHERE identifier = @identifier', {
        ['@identifier'] = ident
    })
    LogDiscord("License: **"..xPlayer.identifier.."** has traded in his "..model.." vehicle and has "..cars.." vehicles left to trade in.")
end)

ESX.RegisterCommand('vippanel', "admin", function(source, args, showError)
    TriggerClientEvent('open:panel', -1)
end)


RegisterCommand('redeemvip', function(source, args)
    TriggerEvent("fly:redeem", args[1], source)
end)

RegisterCommand('vipmenu', function(source)
    TriggerEvent("fly:checkvip", source)
end)





local charset = {}

for i = 48,  57 do table.insert(charset, string.char(i)) end
for i = 65,  90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end


function string.random(length)
	math.randomseed(os.time())
	if length > 0 then
		return string.random(length - 1) .. charset[math.random(1, #charset)]
	else
		return ""
	end
end

function Identifier(idplayer)
    for _,v in ipairs(GetPlayerIdentifiers(idplayer)) do
             if string.match(v, 'license:') then
                  return string.sub(v, 9)
             end
        end
    return ''
end


function LogDiscord(msg)
        PerformHttpRequest(webhook, function(a,b,c)end, "POST", json.encode({embeds={{title="Fly VIP Logs",description=msg, color =3092790}}}), {["Content-Type"]="application/json"})
end
