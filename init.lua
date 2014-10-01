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

	--Get the gametime
	local gameTime = minetest.get_gametime()

	--Loop through all connected players
	for playerName,playerInfo in pairs(players) do
		local player = minetest.get_player_by_name(playerName)
		if player ~= nil then
			-- check if they are moving or not
			players[playerName]["moving"] = player:get_player_control()["up"]

			if playerInfo["state"] == 2 then
				if playerInfo["timeOut"] + SPRINT_TIMEOUT < gameTime then
					players[playerName]["timeOut"] = nil
					players[playerName]["state"] = 0
				end

			--If the player is sprinting, create particles behind him/her
			elseif playerInfo["state"] == 3 and gameTime % 0.1 == 0 then
				local numParticles = math.random(1, 2)
				local playerPos = player:getpos()
				local playerNode = minetest.get_node({x=playerPos["x"], y=playerPos["y"]-1, z=playerPos["z"]})
				if playerNode["name"] ~= "air" then
					for i=1, numParticles, 1 do
						minetest.add_particle({
							pos = {x=playerPos["x"]+math.random(-1,1)*math.random()/2,y=playerPos["y"]+0.1,z=playerPos["z"]+math.random(-1,1)*math.random()/2},
							vel = {x=0, y=5, z=0},
							acc = {x=0, y=-13, z=0},
							expirationtime = math.random(),
							size = math.random()+0.5,
							collisiondetection = true,
							vertical = false,
							texture = "default_dirt.png",
						})
					end
				end
			end

			--Ajust player states
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

