if SERVER then
	include("pvp/pvp_config.lua")
	include("pvp/sv_pvp.lua")
	AddCSLuaFile("pvp/pvp_config.lua")
	AddCSLuaFile("pvp/cl_pvp.lua")
	AddCSLuaFile("pvp/sh_pvp.lua")
end

if CLIENT then
	include("pvp/pvp_config.lua")
	include("pvp/cl_pvp.lua")
end