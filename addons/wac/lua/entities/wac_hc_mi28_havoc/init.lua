include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

ENT.WheelStabilize = -150

ENT.Wheels = {
	{
		mdl = "models/bf2/helicopters/mil mi-28/mi28_w2.mdl",
		pos = Vector(-416.87, 0, 53.31),
		friction = 100,
		mass = 200,
	},
	{
		mdl = "models/bf2/helicopters/mil mi-28/mi28_w1.mdl",
		pos = Vector(48.68, -49.39, 4.15),
		friction = 100,
		mass = 200,
	},
	{
		mdl = "models/bf2/helicopters/mil mi-28/mi28_w1.mdl",
		pos = Vector(48.68, 49.39, 4.15),
		friction = 100,
		mass = 200,
	},
}

function ENT:SpawnFunction(ply, trace)
	if !trace.Hit then return end
	local ent = ents.Create(ClassName)
	ent:SetPos(trace.HitPos + trace.HitNormal * 70)
	ent.Owner = ply
	ent:Spawn()
	ent:Activate()
	return ent
end