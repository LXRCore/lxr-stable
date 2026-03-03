--[[
    ██╗     ██╗  ██╗██████╗        ███████╗████████╗ █████╗ ██████╗ ██╗     ███████╗
    ██║     ╚██╗██╔╝██╔══██╗       ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██║     ██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗ ███████╗   ██║   ███████║██████╔╝██║     █████╗  
    ██║      ██╔██╗ ██╔══██╗╚════╝ ╚════██║   ██║   ██╔══██║██╔══██╗██║     ██╔══╝  
    ███████╗██╔╝ ██╗██║  ██║       ███████║   ██║   ██║  ██║██████╔╝███████╗███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝

    🐺 LXR Stable — Server-Side Logic

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

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 FRAMEWORK BRIDGE — LXR-Core / RSG-Core / VORP Core / Standalone
-- ═══════════════════════════════════════════════════════════════════════════════

local Framework = nil
local FrameworkName = Config.Framework or 'lxr-core'

-- Auto-detect framework if set to auto
if FrameworkName == 'auto' then
    if GetResourceState('lxr-core') == 'started' then
        FrameworkName = 'lxr-core'
    elseif GetResourceState('rsg-core') == 'started' then
        FrameworkName = 'rsg-core'
    elseif GetResourceState('vorp_core') == 'started' then
        FrameworkName = 'vorp_core'
    else
        FrameworkName = 'standalone'
    end
end

-- Load framework export handle
if FrameworkName == 'lxr-core' then
    Framework = exports['lxr-core']
elseif FrameworkName == 'rsg-core' then
    Framework = exports['rsg-core']
end

-- ──────────────────────────────────────────────────────────────────────────────
-- Framework helper: get player data (citizenid + money helpers)
-- ──────────────────────────────────────────────────────────────────────────────

local function GetPlayer(src)
    if FrameworkName == 'lxr-core' or FrameworkName == 'rsg-core' then
        return Framework:GetPlayer(src)
    elseif FrameworkName == 'vorp_core' then
        local user = exports['vorp_core']:GetUser(src)
        if not user then return nil end
        local char = user.getUsedCharacter
        return {
            PlayerData = {
                citizenid = tostring(char.id),
                source    = src,
            },
            Functions = {
                GetMoney = function(self, moneyType)
                    return char.money
                end,
                RemoveMoney = function(self, moneyType, amount, reason)
                    exports['vorp_core']:removeMoney(src, amount)
                    return true
                end,
                AddMoney = function(self, moneyType, amount, reason)
                    exports['vorp_core']:addMoney(src, amount)
                    return true
                end,
            }
        }
    else
        -- Standalone: no economy checks
        return {
            PlayerData = {
                citizenid = tostring(src),
                source    = src,
            },
            Functions = {
                GetMoney    = function(self, moneyType) return 999999 end,
                RemoveMoney = function(self, moneyType, amount, reason) return true end,
                AddMoney    = function(self, moneyType, amount, reason) return true end,
            }
        }
    end
end

local function Notify(src, message, notifyType)
    if FrameworkName == 'lxr-core' then
        TriggerClientEvent('lxr-core:client:Notify', src, message, notifyType or 'error', 5000)
    elseif FrameworkName == 'rsg-core' then
        TriggerClientEvent('rsg-core:client:Notify', src, message, notifyType or 'error', 5000)
    elseif FrameworkName == 'vorp_core' then
        TriggerClientEvent('vorp:TipRight', src, message, 3000)
    else
        TriggerClientEvent('chat:addMessage', src, { args = {'[Stable]', message} })
    end
end

local function ServerLog(action, color, message)
    if FrameworkName == 'lxr-core' then
        TriggerEvent('lxr-log:server:CreateLog', 'shops', action, color, message)
    elseif FrameworkName == 'rsg-core' then
        TriggerEvent('rsg-log:server:CreateLog', 'shops', action, color, message)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 DATABASE INITIALISATION
-- ═══════════════════════════════════════════════════════════════════════════════

local SelectedHorseId = {}
local Horses

local function CreateDatabaseIfNotExists()
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
        print(string.format(
            '[ 🐺 LXR-Stable ] Started successfully | Framework: %s | wolves.land',
            FrameworkName
        ))
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 NET EVENTS
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterNetEvent("lxr-stable:UpdateHorseComponents", function(components, idhorse, MyHorse_entity)
    local src = source
    local encodedComponents = json.encode(components)
    local Player = GetPlayer(src)
    if not Player then return end
    local Playercid = Player.PlayerData.citizenid
    local id = idhorse
    MySQL.query("UPDATE horses SET `components`=@components WHERE `cid`=@cid AND `id`=@id", {components = encodedComponents, cid = Playercid, id = id}, function(done)
        TriggerClientEvent("lxr-stable:client:UpdadeHorseComponents", src, MyHorse_entity, components)
    end)
end)

RegisterNetEvent("lxr-stable:CheckSelectedHorse", function()
    local src = source
    local Player = GetPlayer(src)
    if not Player then return end
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

RegisterNetEvent("lxr-stable:AskForMyHorses", function()
    local src = source
    local Player = GetPlayer(src)
    if not Player then return end
    local Playercid = Player.PlayerData.citizenid
    MySQL.query('SELECT * FROM horses WHERE `cid`=@cid;', {cid = Playercid}, function(horses)
        TriggerClientEvent("lxr-stable:ReceiveHorsesData", src, horses)
    end)
end)

RegisterNetEvent("lxr-stable:BuyHorse", function(data, name)
    local src = source
    local Player = GetPlayer(src)
    if not Player then return end
    local Playercid = Player.PlayerData.citizenid

    MySQL.query('SELECT * FROM horses WHERE `cid`=@cid;', {cid = Playercid}, function(horses)
        if #horses >= Config.MaxNumberOfHorses then
            Notify(src, "You can have a maximum of " .. Config.MaxNumberOfHorses .. " horses!")
            return
        end
        Wait(200)
        if data.IsGold then
            local currentBank = Player.Functions:GetMoney('bank')
            if data.Gold <= currentBank then
                Player.Functions:RemoveMoney("bank", data.Gold, "stable-bought-horse")
                ServerLog('Stable', 'green', "**" .. GetPlayerName(src) .. " (cid: " .. Playercid .. " | id: " .. src .. ")** bought a horse for $" .. data.Gold .. ".")
            else
                Notify(src, "Not enough money!")
                return
            end
        else
            if Player.Functions:RemoveMoney("cash", data.Dollar, "stable-bought-horse") then
                ServerLog('Stable', 'green', "**" .. GetPlayerName(src) .. " (cid: " .. Playercid .. " | id: " .. src .. ")** bought a horse for $" .. data.Dollar .. ".")
            else
                Notify(src, "Not enough money!")
                return
            end
        end
        MySQL.query.await('INSERT INTO horses (`cid`, `name`, `model`) VALUES (@Playercid, @name, @model);',
            {
                Playercid = Playercid,
                name      = tostring(name),
                model     = data.ModelH
            }
        )
    end)
end)

RegisterNetEvent("lxr-stable:SelectHorseWithId", function(id)
    local src = source
    local Player = GetPlayer(src)
    if not Player then return end
    local Playercid = Player.PlayerData.citizenid
    MySQL.query('SELECT * FROM horses WHERE `cid`=@cid;', {cid = Playercid}, function(horse)
        for i = 1, #horse do
            local horseID = horse[i].id
            MySQL.query("UPDATE horses SET `selected`='0' WHERE `cid`=@cid AND `id`=@id", {cid = Playercid, id = horseID}, function(done)
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

RegisterNetEvent("lxr-stable:SellHorseWithId", function(id)
    local modelHorse = nil
    local src = source
    local Player = GetPlayer(src)
    if not Player then return end
    local Playercid = Player.PlayerData.citizenid
    MySQL.query('SELECT * FROM horses WHERE `cid`=@cid;', {cid = Playercid}, function(horses)
        for i = 1, #horses do
            if tonumber(horses[i].id) == tonumber(id) then
                modelHorse = horses[i].model
                MySQL.query('DELETE FROM horses WHERE `cid`=@cid AND`id`=@id;', {cid = Playercid, id = id}, function(result)
                end)
            end
        end

        for k, v in pairs(Config.Horses) do
            for models, values in pairs(v) do
                if models ~= "name" then
                    if models == modelHorse then
                        local price = tonumber(values[3] / 2)
                        Player.Functions:AddMoney("cash", price, "stable-sell-horse")
                        ServerLog('Stable', 'red', "**" .. GetPlayerName(src) .. " (cid: " .. Playercid .. " | id: " .. src .. ")** sold a horse for $" .. price .. ".")
                    end
                end
            end
        end
    end)
end)
