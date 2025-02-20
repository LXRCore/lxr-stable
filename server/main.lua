
local SelectedHorseId = {}
local Horses

CreateThread(function()
	if GetCurrentResourceName() ~= "lxr-stable" then
	    print("=====================================")
	    print("SCRIPT NAME OTHER THAN ORIGINAL")
	    print("YOU SHOULD STOP SCRIPT")
	    print("CHANGE NAME TO: lxr-stable")
	    print("=====================================")
	end

end)

RegisterNetEvent("qbr-stable:UpdateHorseComponents", function(components, idhorse, MyHorse_entity)
	local src = source
	local encodedComponents = json.encode(components)
	local Player = exports['qbr-core']:GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
	local id = idhorse
	MySQL.query("UPDATE horses SET `components`=@components WHERE `cid`=@cid AND `id`=@id", {components = encodedComponents, cid = Playercid, id = id}, function(done)
		TriggerClientEvent("qbr-stable:client:UpdadeHorseComponents", src, MyHorse_entity, components)
	end)
end)

RegisterNetEvent("qbr-stable:CheckSelectedHorse", function()
	local src = source
	local Player = exports['qbr-core']:GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid

	MySQL.query('SELECT * FROM horses WHERE `cid`=@cid;', {cid = Playercid}, function(horses)
		if #horses ~= 0 then
			for i = 1, #horses do
				if horses[i].selected == 1 then
					TriggerClientEvent("VP:HORSE:SetHorseInfo", src, horses[i].model, horses[i].name, horses[i].components)
				end
			end
		end
	end)
end)

RegisterNetEvent("qbr-stable:AskForMyHorses", function()
	local src = source
	local horseId = nil
	local components = nil
	local Player = exports['qbr-core']:GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
	MySQL.query('SELECT * FROM horses WHERE `cid`=@cid;', {cid = Playercid}, function(horses)
		if horses[1]then
			horseId = horses[1].id
		else
			horseId = nil
		end

		MySQL.query.await('SELECT * FROM horses WHERE `cid`=@cid;', {cid = Playercid}, function(components)
			if components[1] then
				components = components[1].components
			end
		end)
		TriggerClientEvent("qbr-stable:ReceiveHorsesData", src, horses)
	end)
end)

RegisterNetEvent("qbr-stable:BuyHorse", function(data, name)
	local src = source
	local Player = exports['qbr-core']:GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid

	MySQL.query('SELECT * FROM horses WHERE `cid`=@cid;', {cid = Playercid}, function(horses)
		if #horses >= Config.MaxNumberOfHorses then
			TriggerClientEvent('QBCore:Notify', src, 9, "You can have a maximum of "..Config.MaxNumberOfHorses.." horses!", 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
			return
		end
		Wait(200)
		if data.IsGold then
			local currentBank = Player.Functions.GetMoney('bank')
			if data.Gold <= currentBank then
				local bank = Player.Functions.RemoveMoney("bank", data.Gold, "stable-bought-horse")
				TriggerEvent('qbr-log:server:CreateLog', 'shops', 'Stable', 'green', "**"..GetPlayerName(Player.PlayerData.source) .. " (citizenid: "..Player.PlayerData.citizenid.." | id: "..Player.PlayerData.source..")** bought a horse for $"..data.Gold..".")
			else
				TriggerClientEvent('QBCore:Notify', src, 9, "Not enough money!", 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
				return
			end
		else
			if Player.Functions.RemoveMoney("cash", data.Dollar, "stable-bought-horse") then
				TriggerEvent('qbr-log:server:CreateLog', 'shops', 'Stable', 'green', "**"..GetPlayerName(Player.PlayerData.source) .. " (citizenid: "..Player.PlayerData.citizenid.." | id: "..Player.PlayerData.source..")** bought a horse for $"..data.Dollar..".")
			else
				TriggerClientEvent('QBCore:Notify', src, 9, "Not enough money!", 5000, 0, 'mp_lobby_textures', 'cross', 'COLOR_WHITE')
				return
			end
		end
	MySQL.query.await('INSERT INTO horses (`cid`, `name`, `model`) VALUES (@Playercid, @name, @model);',
		{
			Playercid = Playercid,
			name = tostring(name),
			model = data.ModelH
		}, function(rowsChanged)

		end)
	end)
end)

RegisterNetEvent("qbr-stable:SelectHorseWithId", function(id)
	local src = source
	local Player = exports['qbr-core']:GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
	MySQL.query('SELECT * FROM horses WHERE `cid`=@cid;', {cid = Playercid}, function(horse)
		for i = 1, #horse do
			local horseID = horse[i].id
			MySQL.query("UPDATE horses SET `selected`='0' WHERE `cid`=@cid AND `id`=@id", {cid = Playercid,  id = horseID}, function(done)
			end)

			Wait(300)

			if horse[i].id == id then
				MySQL.query("UPDATE horses SET `selected`='1' WHERE `cid`=@cid AND `id`=@id", {cid = Playercid, id = id}, function(done)
					TriggerClientEvent("VP:HORSE:SetHorseInfo", src, horse[i].model, horse[i].name, horse[i].components)
				end)
			end
		end
	end)
end)

RegisterNetEvent("qbr-stable:SellHorseWithId", function(id)
	local modelHorse = nil
	local src = source
	local Player = exports['qbr-core']:GetPlayer(src)
	local Playercid = Player.PlayerData.citizenid
	MySQL.query('SELECT * FROM horses WHERE `cid`=@cid;', {cid = Playercid}, function(horses)

		for i = 1, #horses do
		   if tonumber(horses[i].id) == tonumber(id) then
				modelHorse = horses[i].model
				MySQL.query('DELETE FROM horses WHERE `cid`=@cid AND`id`=@id;', {cid = Playercid,  id = id}, function(result)
				end)
			end
		end

		for k,v in pairs(Config.Horses) do
			for models,values in pairs(v) do
				if models ~= "name" then
					if models == modelHorse then
						local price = tonumber(values[3]/2)
						Player.Functions.AddMoney("cash", price, "stable-sell-horse")
						TriggerEvent('qbr-log:server:CreateLog', 'shops', 'Stable', 'red', "**"..GetPlayerName(Player.PlayerData.source) .. " (citizenid: "..Player.PlayerData.citizenid.." | id: "..Player.PlayerData.source..")** sold a horse for $"..price..".")
					end
				end
			end
		end
	end)
end)


function CreateDatabaseIfNotExists()
	MySQL.query.await([[
		CREATE TABLE IF NOT EXISTS `horses` (
		`id` int(11) NOT NULL AUTO_INCREMENT,
		`cid` varchar(50) NOT NULL,
		`selected` int(11) NOT NULL DEFAULT 0,
		`model` varchar(50) NOT NULL,
		`name` varchar(50) NOT NULL,
		`components`  varchar(5000) NOT NULL DEFAULT '{}',
		PRIMARY KEY (`id`))
		]]
	)
end

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		CreateDatabaseIfNotExists()
	end
end)
