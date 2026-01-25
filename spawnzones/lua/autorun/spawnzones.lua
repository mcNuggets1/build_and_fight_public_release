SZ = SZ or {Data = {}}

if SERVER then
	include("sz/sv_init.lua")
	AddCSLuaFile("sz/cl_init.lua")
	include("sz/sh_init.lua")
	AddCSLuaFile("sz/sh_init.lua")
	include("sz/sh_config.lua")
	AddCSLuaFile("sz/sh_config.lua")
end

if CLIENT then
	include("sz/cl_init.lua")
	include("sz/sh_init.lua")
	include("sz/sh_config.lua")
end