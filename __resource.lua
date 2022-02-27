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

-- Citeste si README.md in cazul in care folosesti okoknotify sau vrp_mysql

resource_manifest_version 'adamant'

description "vrp_warns made by AX"
dependency "vrp"

client_scripts {
	"lib/Proxy.lua",
	"lib/Tunnel.lua",
}

server_scripts {
    "@vrp/lib/utils.lua",
	"server.lua",
}