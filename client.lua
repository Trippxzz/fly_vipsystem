ESX = nil
local PlayerData = {}
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(500)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    Citizen.Wait(800)
    PlayerData = ESX.GetPlayerData() -- Setting PlayerData vars
end)
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local idplayer, rname, type, vips, car, ped, money, useped = 'N/A', 'N/A', 'N/A', 'N/A', nil, nil, nil, false

RegisterNetEvent('open:panel')
AddEventHandler('open:panel', function()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'panel', {
        title = 'VIP Admin Menu',
        align = 'right',
        elements = {
            {label = 'Generate Code', value = 'generate'},
            {label = 'Give VIP', value = 'give'},
            {label = 'VIP List', value = 'list'}, 
            {label = '<span style = color:red; span>Close</span>', value = 'close'}
        }}, function(data, menu)
            local action = data.current.value 
            if action == 'generate' then
                TypeMenuGenerate()
                menu.close()
            elseif action == 'give' then
                GivePanel()
            elseif action == 'list' then
                local elements = {}

			ESX.TriggerServerCallback("fly:vipplayers", function(playersvip)

				if #playersvip == 0 then
					ESX.ShowNotification("There are no players with VIP Privileges")
					return
				end

				for i = 1, #playersvip, 1 do
					table.insert(elements, {label = "Identifier: " .. playersvip[i].identifier ,  value = playersvip[i].identifier })
				end

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'vip_list',
					{
						title = "List Players VIP",
						align = "right",
						elements = elements
					},
				function(data2, menu2)

					local player = data2.current.value
                    if player then
                        PlayerPanel(player)
                    end
					menu2.close()

				end, function(data2, menu2)
					menu2.close()
				end)
			end)

            elseif action == 'close' then
                ESX.UI.Menu.CloseAll()
            end
        end, function(data, menu)
            menu.close()
    end)
end)

function PlayerPanel(player)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'playerpanel', {
        title = 'Player management',
        align = 'right',
        elements = {
            {label = 'Set Ped', value = 'setped'},
            {label = 'Remove VIP', value = 'removevip'},
            {label = '<span style = color:red; span>Close</span>', value = 'close'}
        }}, function(data, menu)
            local action = data.current.value 
            if action == 'setped' then
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'ped', {
                    title = 'Name PED'
                    }, function(data2, menu2)
                         haskeyped = data2.value
                         	menu2.close()
                            TriggerServerEvent('fly:setped', player, haskeyped)
                        end, function(data, menu)
                      menu.close()
                end)
            elseif action == 'removevip' then
                RemoveVIP(player)
            elseif action == 'close' then
                ESX.UI.Menu.CloseAll()
            end
        end, function(data, menu)
            menu.close()
    end)
end
local idplayerconfirm = nil
RegisterNetEvent('fly:confirmid')
AddEventHandler('fly:confirmid', function(idplayerconfirm, name)
    rname = name 
    idplayer = idplayerconfirm
    GivePanel()
end)

function GivePanel()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'givepanel', {
        title = 'VIP Admin Menu',
        align = 'right',
        elements = {
            {label = 'ID: '..idplayer, value = 'id'},
            {label = 'Name: '..rname, value = nil},
            {label = 'Type: '..type, value = 'type'},
            {label = 'Confirm', value = 'confirm'}, 
            {label = '<span style = color:red; span>Close</span>', value = 'close'}
        }}, function(data, menu)
            local action = data.current.value 
            if action == 'id' then
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'tag', {
                    title = 'ID Player'
                    }, function(data2, menu2)
                         idplayer = tonumber(data2.value)
                         	menu2.close()
                            TriggerServerEvent('fly:checkid', idplayer)
							-- realid = GetPlayerServerId(PlayerId(idplayer))
							-- rname  = GetPlayerName(PlayerId(realid))
                            menu.close()
                            -- GivePanel()
                        end, function(data, menu)
                      menu.close()
                end)
            elseif action == 'type' then
                TypeMenu()
            elseif action == 'confirm' then
                TriggerServerEvent('give:vip', idplayer, type, car, ped, money)
                idplayer = 'N/A'
                rname = 'N/A'
                type = 'N/A'
                realid = nil
                car = nil
                money = nil
                ped = nil
                menu.close()
            elseif action == 'close' then
                ESX.UI.Menu.CloseAll()
            end
        end, function(data, menu)
            menu.close()
            idplayer = 'N/A'
            rname = 'N/A'
            type = 'N/A'
            realid = nil
            car = nil
            money = nil
            ped = nil
    end)
end

function RemoveVIP(player)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'removepanel', {
        title = 'VIP Admin Menu',
        align = 'right',
        elements = {
            {label = 'Remove VIP', value = 'remove'},
            {label = '<span style = color:red; span>Close</span>', value = 'close'}
        }}, function(data, menu)
            local action = data.current.value 
            if action == 'remove' then
                TriggerServerEvent("fly:removevip", player)
                ESX.ShowNotification("You removed the VIP privilege of the player with identifier "..player)
                menu.close()
            elseif action == 'close' then
                ESX.UI.Menu.CloseAll()
            end
        end, function(data, menu)
            menu.close()
    end)
  
end

function TypeMenu()
    local elements = {}
    for k,v in pairs(Config.Vips) do
        table.insert(elements, {label = v.Icon.." VIP: " .. v.Name .." | Cars:".. v.Cars .. " | Ped?: ".. v.Ped .. " | Money: "..v.Money,  value = v.Name, cars = v.Cars, peds = v.Ped, moneyy = v.Money})
    end

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vip_type',
        {
            title = "Type VIP",
            align = "right",
            elements = elements
        },
    function(data2, menu2)

        local action = data2.current.value
        if action then
            type = action
            car = data2.current.cars
            ped = data2.current.peds
            money = data2.current.moneyy
            GivePanel() 
        end
        menu2.close()

    end, function(data2, menu2)
        menu2.close()
    end)
end

function TypeMenuGenerate()
    local elements = {}
    for k,v in pairs(Config.Vips) do
        table.insert(elements, {label = "VIP: " .. v.Name .." | Cars:".. v.Cars .. "| Ped?: ".. v.Ped .. "| Money: "..v.Money,  value = v.Name, cars = v.Cars, peds = v.Ped, moneyy = v.Money })
    end
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vip_type',
        {
            title = "Type VIP",
            align = "right",
            elements = elements
        },
    function(data2, menu2)

        local action = data2.current.value
        if action then
            type = action
            car = data2.current.cars
            ped = data2.current.peds
            money = data2.current.moneyy
            TriggerServerEvent('code:generate', type, car, ped, money)
        end
        menu2.close()
        type = 'N/A'

    end, function(data2, menu2)
        menu2.close()
        type = 'N/A'
    end)
end


RegisterNetEvent('fly:success')
AddEventHandler('fly:success', function(vip, cars, peds, moneyx2)
    local elements = {}
    local id = GetPlayerServerId(PlayerId()) 
        table.insert(elements, {label = 'Your VIP: '..vip, value = nil})
        if cars ~= 0 then
        table.insert(elements, {label = 'Choose my cars ['..cars..']', value = 'choosecar'})
        end
        if not useped then
            table.insert(elements, {label = 'Use my ped ['..peds..']', value = 'ped'})
        else 
            table.insert(elements, {label = 'Restore Character', value = 'fixpj'})
        end
        if moneyx2 ~= 0 then
        table.insert(elements, {label = 'Claim my money $'..moneyx2, value = 'claimmoney'})
        end
        

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vipmenu', {
            title = 'VIP Menu', 
            align = 'right',
            elements = elements

        }, function(data, menu)
            local val = data.current.value
            if val == 'choosecar' then
                Menutochoosevehicle(vip, cars)
            elseif val == 'ped' then
                useped = true
                TriggerServerEvent('fly:checkped')
                 menu.close()
            elseif val == 'fixpj' then
                useped = false
                local hp = GetEntityHealth(PlayerPedId())
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                    local isMale = skin.sex == 0
                    TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                            TriggerEvent('skinchanger:loadSkin', skin)
                            TriggerEvent('esx:restoreLoadout')
                            TriggerEvent('dpc:ApplyClothing')
                            SetEntityHealth(PlayerPedId(), hp)
                        end)
                    end)
                end)
                menu.close()
            elseif val == 'claimmoney' then
                TriggerServerEvent('claim:money')
            end
        end, function(data, menu)
            menu.close()
        end)

end)

RegisterNetEvent('fly:spawnped')
AddEventHandler('fly:spawnped', function(ped)
    if ped ~= 'notavailable' then
        local modelHash = GetHashKey(ped)
        SetPedDefaultComponentVariation(PlayerPedId())
        ESX.Streaming.RequestModel(modelHash, function()
            SetPlayerModel(PlayerId(), modelHash)
            SetPedDefaultComponentVariation(PlayerPedId())
            SetModelAsNoLongerNeeded(modelHash)
            TriggerEvent('esx:restoreLoadout')
            SetPedComponentVariation(PlayerPedId(), 8, 0, 0, 2)
        end)
    else
        ESX.ShowNotification("Your vip is not entitled to a ped")
    end
end)

function Menutochoosevehicle(vip, cars)
    local elements = {}  
    for k,v in pairs(Config.Cars) do
        if vip == v.category then
        table.insert(elements,{label = v.label, model = v.model, category = v.category})
        end
    end
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vip_type',
        {
            title = "Choose your Car ["..cars.."]",
            align = "right",
            elements = elements
        },
    function(data2, menu2)

        local action = data2.current.model
        if action then
            local coords    = GetEntityCoords(PlayerPedId())
            ESX.Game.SpawnVehicle(action, coords, 0.0, function(vehicle) 
                if DoesEntityExist(vehicle) then

                    local vehicleprops = ESX.Game.GetVehicleProperties(vehicle)
                    SetPedIntoVehicle(PlayerPedId(),vehicle,-1)
                    TriggerServerEvent('fly:givecar', action, vehicleprops)	
                end		
            end)
            ESX.UI.Menu.CloseAll()
        end
        menu2.close()

    end, function(data2, menu2)
        menu2.close()
    end)
end