AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Use(activator)
	if !activator:IsPlayer() then return end
	Crates.HandlePlayerOpening(activator, self)
end