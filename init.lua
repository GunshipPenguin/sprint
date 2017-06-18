--[[
Sprint mod for Minetest by GunshipPenguin

To the extent possible under law, the author(s)
have dedicated all copyright and related and neighboring rights 
to this software to the public domain worldwide. This software is
distributed without any warranty. 
]]

--Configuration variables, these are all explained in README.md
SPRINT_KEY = minetest.settings:get("sprint_key")
if SPRINT_KEY == nil then SPRINT_KEY = "e" end

SPRINT_SPEED = minetest.settings:get("sprint_speed")
if SPRINT_SPEED == nil then SPRINT_SPEED = 1.8 end

SPRINT_JUMP = minetest.settings:get("sprint_jump")
if SPRINT_JUMP == nil then SPRINT_JUMP = 1.1 end

SPRINT_STAMINA = minetest.settings:get("sprint_stamina")
if SPRINT_STAMINA == nil then SPRINT_STAMINA = 20 end

SPRINT_TIMEOUT = minetest.settings:get("sprint_timeout") --Only used if SPRINT_KEY = "w"
if SPRINT_TIMEOUT == nil then SPRINT_TIMEOUT = 0.5 end

if minetest.get_modpath("hudbars") ~= nil then
	hb.register_hudbar("sprint", 0xFFFFFF, "Stamina",
		{ bar = "sprint_stamina_bar.png", icon = "sprint_stamina_icon.png", bgicon = "sprint_stamina_bgicon.png" },
		SPRINT_STAMINA, SPRINT_STAMINA,
		false, "%s: %.1f/%.1f")
	SPRINT_HUDBARS_USED = true
else
	SPRINT_HUDBARS_USED = false
end

if SPRINT_KEY == "w" then
	dofile(minetest.get_modpath("sprint") .. "/wsprint.lua")
elseif SPRINT_KEY == "e" then
	dofile(minetest.get_modpath("sprint") .. "/esprint.lua")
else
	minetest.log("error", "Sprint Mod - sprint_key is not set properly, using e to sprint")
	dofile(minetest.get_modpath("sprint") .. "/esprint.lua")
end
