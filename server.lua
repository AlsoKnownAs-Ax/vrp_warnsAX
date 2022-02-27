--[[
---------------------------------------------------------------
----------------    Warns Script made by Ax    ---------------- 
--------       Am decis sa fac public acest script     --------     
--------      deoarece a fost facut acum ceva timp     --------
--------      si cred ca sunt si variante mai bune     --------
-----------               pe internet               -----------
-----------         Script made in 16/06/2021         ---------
------                 Discord : --Ax-#0018              ------
---------------------------------------------------------------
--]]

--[[
    Astept sa apara baietii care o sa dea repost dupa ce inlcuiesc numele meu cu numele lor :))))))))))))))
]]

--MySQL = module("vrp_mysql", "MySQL")
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_warns")

--[[MySQL.createCommand("vRP/get_warns", "SELECT warns FROM vrp_users WHERE id = @user_id")
MySQL.createCommand("vRP/warn", "UPDATE vrp_users SET warns = warns + 1 WHERE id = @user_id")
MySQL.createCommand("vRP/remove_warn", "UPDATE vrp_users SET warns = warns - 1 WHERE id = @user_id")

MySQL.createCommand("vRP/clear_warns", "UPDATE vrp_users SET warns = 0 WHERE id = @user_id")]]



Discord_warn_log = '' -- Pune aici webhookul de la discord (warns)
Discord_unwarn_log = '' -- Pune aici webhookul de la discord (unwarns)




RegisterCommand("warns",function(source,args)
    local user_id = vRP.getUserId({source})
        if user_id ~= nil then
            local rows = exports['ghmattimysql']:executeSync("SELECT warns FROM vrp_users WHERE id = @user_id", {user_id = user_id})
            warn_number = rows[1].warns
            if warn_number == 0 then
                vRPclient.notify(source , {"Ai ~g~0 ~w~warnuri"})
                --TriggerClientEvent('okokNotify:Alert', source, "", "Ai ~g~0 ~w~warnuri", 3000, 'info')
            else
                vRPclient.notify(source , {"Ai ~r~"..warn_number.." ~w~warnuri"})
               -- TriggerClientEvent('okokNotify:Alert', source, "", "Ai ~r~"..warn_number.." ~w~warnuri", 3000, 'info')
            end
        end
end)


function vRP.kick(source,reason)
    DropPlayer(source,reason)
end


function vRP.getBannedExpiredDate(time)
    local ora = os.date("%H:%M:%S")
    local creation_date = os.date("%d/%m/%Y")
    local dayValue, monthValue, yearValue = string.match(creation_date, '(%d+)/(%d+)/(%d+)')
    dayValue, monthValue, yearValue = tonumber(dayValue), tonumber(monthValue), tonumber(yearValue)
    return ""..os.date("%d/%m/%Y",os.time{year = yearValue, month = monthValue, day = dayValue }+time*24*60*60).." : "..ora..""
end

function vRP.banTemp(source,reason,admin,timp)
    local user_id = vRP.getUserId({source})
    if user_id ~= nil then
      data = os.date("%d/%m/%Y : %H:%M:%S")
      expireDate = vRP.getBannedExpiredDate(timp)
      if(tostring(admin) ~= "Consola")then
        theAdmin = vRP.getUserId({admin})
        adminName = vRP.getPlayerName({admin})
        banBy = adminName.." ["..theAdmin.."]"
      else
        banBy = "Consola"
      end
      vRP.setBannedTemp(user_id,true,reason,admin,timp)
      motiv = "[Galaxy] Ai primit BAN TEMPORAR!\nBanat De: "..banBy.."\nMotiv: "..reason.."\nTimp: "..timp.." Zile\nID-ul Tau: ["..user_id.."]\nBanat Pe Data De: "..data.."\nExpira Pe: "..expireDate.."\n\n⮚ Unban Automat Dupa Ce Trece Timpul ⮘\n\n⚠ Daca crezi ca ai fost banat pe nedrept, poti face cerere de unban pe Discord: discord.io/GalaxyRP ⚠"
      vRP.kick(source,motiv)
    end
end


function vRP.setBannedTemp(user_id,banned,reason,by,timp)
    if(banned == false)then
      exports.ghmattimysql:execute("UPDATE vrp_users SET banned = @banned, bannedTemp = 0, bannedReason = @reason, bannedBy = @bannedBy, BanTempZile = 0, BanTempData = @date, BanTempExpire = @expireDate WHERE id = @user_id", {user_id = user_id, banned = banned, reason = "", bannedBy = "", date = "", expireDate = ""}, function()end)
    else
      banTimp = os.time() + timp * 24 * 60 * 60
      data = os.date("%d/%m/%Y : %H:%M:%S")
      expireDate = vRP.getBannedExpiredDate(timp)
      if(tostring(by) ~= "Consola")then
        theAdmin = vRP.getUserId({by})
        adminName = vRP.getPlayerName({by})
        banBy = adminName.." ["..theAdmin.."]"
      else
        banBy = "Consola"
      end
      exports.ghmattimysql:execute("UPDATE vrp_users SET bannedTemp = @durata, bannedReason = @reason, bannedBy = @bannedBy, BanTempZile = @time, BanTempData = @date, BanTempExpire = @expireDate WHERE id = @user_id", {user_id = user_id, durata = banTimp, reason = reason, bannedBy = banBy, time = timp, date = data, expireDate = expireDate}, function()end)
    end
end


local function ch_unwarn (player,choice)
    local user_id = vRP.getUserId({player})
    local time = os.date("%d/%m/%Y %X")
        if user_id ~= nil then
            vRP.prompt({player , "Jucator ID:", "", function(player,target_id)
                target_id = parseInt(target_id)
                target_src = vRP.getUserSource({target_id})
                local rows = exports['ghmattimysql']:executeSync("SELECT * FROM vrp_users WHERE id = @user_id", {user_id = target_id})
                warn_number = rows[1].warns
                if target_id == user_id then
                    vRPclient.notify(player , {"~r~Nu iti poti da singur unwarn"})
                    --TriggerClientEvent('okokNotify:Alert', player, "", "Nu iti poti da singur unwarn", 3000, 'error')
                elseif target_src ~= nil then
                    if warn_number == 0 then
                        vRPclient.notify(player,{"~r~Acest jucator are deja 0 Warnuri"})
                        --TriggerClientEvent('okokNotify:Alert', player, "", "Acest jucator are deja 0 Warnuri", 3000, 'error')
                    else
                       -- MySQL.execute("vRP/remove_warn",{user_id = target_id})
                        exports.ghmattimysql:execute("UPDATE vrp_users SET warns = warns - 1 WHERE id = @user_id",{user_id = target_id}, function(data)end)
                        TriggerClientEvent("chatMessage", -1, "^1Jucatorul ^0".. vRP.getPlayerName({target_src}) .. " ^1a primit unwarn de la ^0" .. vRP.getPlayerName({player}))
                        local embed = {
                            {
                            ["color"] = 1234521,
                            ["title"] = "".. "__UNWARN__".."",
                            ["description"] = "[".. target_id .. "] a primit unwarn de la ".. vRP.getPlayerName({player}) .. "\nWarnuri ramase : ".. warn_number - 1 .."/3",
                            ["thumbnail"] = {
                                ["url"] = "https://i.imgur.com/uZahVTQ.png",
                            },
                            ["footer"] = {
                            ["text"] = ""..time.."",
                            },
                            }
                        }
                    PerformHttpRequest(Discord_unwarn_log, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
                    end
                else
                    if warn_number == 0 then
                        vRPclient.notify(player , {"~r~Acest jucator are deja 0 Warnuri"})
                        --TriggerClientEvent('okokNotify:Alert', player, "", "Acest jucator are deja 0 Warnuri", 3000, 'error')
                    else
                       -- MySQL.execute("vRP/remove_warn",{user_id = target_id})
                        exports.ghmattimysql:execute("UPDATE vrp_users SET warns = warns - 1 WHERE id = @user_id",{user_id = target_id}, function(data)end)
                        TriggerClientEvent("chatMessage", -1, "^1Jucatorul ^0".. tostring(rows[1].username) .." ^1a primit unwarn de la ^0" .. vRP.getPlayerName({player}))
                        local embed = {
                            {
                            ["color"] = 1234521,
                            ["title"] = "".. "__UNWARN__".."",
                            ["description"] = "[".. target_id .. "] a primit unwarn de la ".. vRP.getPlayerName({player}) .. "\nWarnuri ramase : ".. warn_number - 1 .."/3",
                            ["thumbnail"] = {
                                ["url"] = "https://i.imgur.com/uZahVTQ.png",
                            },
                            ["footer"] = {
                            ["text"] = ""..time.."",
                            },
                        }
                    }
                    PerformHttpRequest(Discord_unwarn_log, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
                    end
                end
            end})
        end
    end
    
    local function ch_warn (player,choice)
    local user_id = vRP.getUserId({player})
    local time = os.date("%d/%m/%Y %X")
        if user_id ~= nil then
            vRP.prompt({player, "Jucator ID:", "", function(player, target_id)
            if target_id ~= nil and target_id ~= "" then
                target_id = parseInt(target_id)
                target_src = vRP.getUserSource({target_id})
                local rows = exports['ghmattimysql']:executeSync("SELECT * FROM vrp_users WHERE id = @user_id", {user_id = target_id})
                if rows[1].warns == nil then
                    return
                end
                if target_id == 1 or target_id == 2 or target_id == 3 or target_id == 4 then -- Pune aici id-urile care sa fie imune la warn
                    vRPclient.notify(player,{"~r~WOW be carefull, poti sa devii bankrupt"})
                    --TriggerClientEvent('okokNotify:Alert', player, "", "WOW be carefull, poti sa devii bankrupt", 3000, 'error')
                elseif target_id == user_id then
                    vRPclient.notify(player, {"~r~Nu iti poti da warn singur"})
                   -- TriggerClientEvent('okokNotify:Alert', player, "", "Nu iti poti da warn singur", 3000, 'error')
                else
                    vRP.prompt({player, "Motiv:", "", function(player,reason)
                        reason = tostring(reason)
                        reasonban = "3/3 Warns"
                        if reason then
                            --MySQL.execute("vRP/get_warns", {user_id = target_id})
                            local rows = exports['ghmattimysql']:executeSync("SELECT warns FROM vrp_users WHERE id = @user_id", {user_id = target_id})
                            warn_number = rows[1].warns
                            local embed = {
                                {
                                  ["color"] = 16711680,
                                  ["title"] = "".. "__WARN__".."",
                                  ["description"] = "[".. target_id .. "] a primit warn de la ".. vRP.getPlayerName({player}) .." (".. warn_number + 1 .."/3) \nMotiv : ".. reason,
                                  ["thumbnail"] = {
                                    ["url"] = "https://i.imgur.com/uZahVTQ.png",
                                  },
                                  ["footer"] = {
                                  ["text"] = ""..time.."",
                                  },
                                }
                        }
                        PerformHttpRequest(Discord_warn_log, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
                            if warn_number == 2 then
                                --MySQL.execute("vRP/clear_warns" , {user_id = target_id})
                                exports.ghmattimysql:execute("UPDATE vrp_users SET warns = 0 WHERE id = @user_id",{user_id = target_id}, function(data)end)
                                data = os.date("%d/%m/%Y : %H:%M:%S")
                                local timp = 7
                                if target_src ~= nil then
                                    TriggerClientEvent("chatMessage", -1, "^1Jucatorul ^0".. vRP.getPlayerName({target_src}) .." ^1a fost banat Temporar pentru 7 zile de catre ^0" .. vRP.getPlayerName({player}))
                                    TriggerClientEvent("chatMessage", -1, "^1Motiv :^0".. reasonban)
                                    vRP.banTemp(target_src,reasonban,player,timp)
                                else
                                    TriggerClientEvent("chatMessage", -1, "Jucatorul".. tostring(rows[1].username) .. " ^1a fost banat Temporar pentru 7 zile de catre" .. vRP.getPlayerName({player}))
                                    TriggerClientEvent("chatMessage", -1, "^1Motiv :^0".. reasonban)
                                    vRP.setBannedTemp(target_id,true,reasonban,player,timp)
                                end
                            elseif warn_number == 0 then
                                --MySQL.execute("vRP/warn", {user_id = target_id})
                                exports.ghmattimysql:execute("UPDATE vrp_users SET warns = warns + 1 WHERE id = @user_id",{user_id = target_id}, function(data)end)
                                if target_src ~= nil then
                                    TriggerClientEvent("chatMessage", -1, "^1Jucatorul ^0".. vRP.getPlayerName({target_src}) .. " ^1a primit 1/3 warns de la ^0" .. vRP.getPlayerName({player}))
                                    TriggerClientEvent("chatMessage", -1, "^1Motiv :^0".. reason)
                                else
                                    TriggerClientEvent("chatMessage", -1, "^1Jucatorul ^0".. tostring(rows[1].username) .." ^1a primit 1/3 warns de la ^0" .. vRP.getPlayerName({player}))
                                    TriggerClientEvent("chatMessage", -1, "^1Motiv :^0".. reason)
                                end
                            elseif warn_number == 1 then
                                --MySQL.execute("vRP/warn", {user_id = target_id})
                                exports.ghmattimysql:execute("UPDATE vrp_users SET warns = warns + 1 WHERE id = @user_id",{user_id = target_id}, function(data)end)
                                if target_src ~= nil then
                                    TriggerClientEvent("chatMessage", -1, "^1Jucatorul ^0".. vRP.getPlayerName({target_src}) .." ^1a primit 2/3 warns de la ^0" .. vRP.getPlayerName({player}))
                                    TriggerClientEvent("chatMessage", -1, "^1Motiv :^0".. reason)
                                else
                                    TriggerClientEvent("chatMessage", -1, "^1Jucatorul ^0".. tostring(rows[1].username) .." ^1a primit 2/3 warns de la ^0" .. vRP.getPlayerName({player}))
                                    TriggerClientEvent("chatMessage", -1, "^1Motiv :^0".. reason)
                                end
                            end
                        else
                            vRPclient.notify(player, {"~r~Nu ai introdus un motiv valid"})
                            --TriggerClientEvent('okokNotify:Alert', player, "", "Nu ai introdus un motiv valid", 3000, 'error')
                        end
                    end})
                end
            else
                vRPclient.notify(player, {"~r~Nu ai selectat un ID valid"})
                --TriggerClientEvent('okokNotify:Alert', player, "", "Nu ai selectat un ID valid", 3000, 'error')
            end
            end})
        end
    end

vRP.registerMenuBuilder({"admin", function(add, data)
	local user_id = vRP.getUserId({data.player})
	if user_id ~= nil then
		local choices = {}
		if(vRP.isUserMod({user_id}))then
            choices["Admin Warn Jucator"] = {ch_warn, "Da-i Warn Unui Jucator Online/Offline"}
            if(vRP.isUserHeadOfStaff({user_id}))then
                choices["Admin UnWarn Jucator"] = {ch_unwarn, "Da-i UnWarn Unui Jucator Online/Offline"}
            end	
		end
		add(choices)
	end
end})