SP = {
	Data = {}
}

if SERVER then
	include("spawnprotection/sv_init.lua")
	AddCSLuaFile("spawnprotection/cl_init.lua")
	AddCSLuaFile("spawnprotection/sv_init.lua")
end

if CLIENT then
	include("spawnprotection/cl_init.lua")
end