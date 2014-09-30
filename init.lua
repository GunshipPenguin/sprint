--Sprint mod for minetest by GunshipPenguin

--CHANGE THESE VARIABLES TO ADJUST SPRINT SPEED/JUMP HEIGHT
--1 represents normal speed/jump height so 1.5 would mean 50% more and 2.0 would be 100% more
local SPRINT_SPEED = 1.5 --Speed while sprinting
local SPRINT_JUMP = 1.1 --Jump height while sprinting

--SPRINT_TIMEOUT is the amount of time, in seconds, that the player has to double tap w in order to begin sprinting
--You shouldn't have to change this
local SPRINT_TIMEOUT = 0.25

local players = {}
minetest.register_on_joinplayer(function(player)
	players[player:get_player_name()] = {state = 0, timeOut = 0}
end)
minetest.register_on_leaveplayer(function(player)
	playerName = player:get_player_name()
	players[playerName] = nil
end)
minetest.register_globalstep(function(dtime)

	--Loop through all connected players and check if they are moving or not
	for playerName,playerInfo in pairs(players) do
		players[playerName]["moving"] = minetest.get_player_by_name(playerName):get_player_control()["up"]
	end
	
	--Get the gametime
	local gameTime = minetest.get_gametime()
	
	--Loop through all connected players and set their state (0=stopped, 1=moving, 2=primed, 3=sprinting)
	for playerName,playerInfo in pairs(players) do
	
		local player = minetest.get_player_by_name(playerName)
		if player ~= nil then
			
			if playerInfo["state"] == 2 then
				if playerInfo["timeOut"] + SPRINT_TIMEOUT < gameTime then
					players[playerName]["timeOut"] = nil
					players[playerName]["state"] = 0
				end
			end
			
			if players[playerName]["moving"] == false and playerInfo["state"] == 3 then --Stopped
				players[playerName]["state"] = 0
				player:set_physics_override({speed=1.0,jump=1.0})
			elseif players[playerName]["moving"] == true and playerInfo["state"] == 0 then --Moving
				players[playerName]["state"] = 1
			elseif players[playerName]["moving"] == false and playerInfo["state"] == 1 then --Primed
				players[playerName]["state"] = 2
				players[playerName]["timeOut"] = gameTime
			elseif players[playerName]["moving"] == true and playerInfo["state"] == 2 then --Sprinting
				players[playerName]["state"] = 3
				player:set_physics_override({speed=SPRINT_SPEED,jump=SPRINT_JUMP})
			end
		end
	end
end)
