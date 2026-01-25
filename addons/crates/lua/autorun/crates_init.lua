Crates = {}

if SERVER then
	AddCSLuaFile("crates/cl_crates.lua")
	AddCSLuaFile("crates/sh_crate_config.lua")
	include("crates/sv_crates.lua")
	include("crates/sv_crate_bonuses.lua")
	include("crates/sv_crate_spawnpoints.lua")
	include("crates/sh_crate_config.lua")
end

if CLIENT then
	include("crates/cl_crates.lua")
	include("crates/sh_crate_config.lua")
end