
include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then return end
	local ent=ents.Create(ClassName)
	ent:SetPos(tr.HitPos+tr.HitNormal*55)
	ent.Owner=ply
	ent:Spawn()
	ent:Activate()
	self.Sounds=table.Copy(sndt)
	return ent
end

--[[
	Defines how the aircraft handles depending on where wind is coming from.
	Rotation defines how it rotates,
	Lift how it rises, sinks or gets pushed right/left,
	Rail defines how stable it is on its path, the higher the less it drifts when turning
]]
ENT.Aerodynamics = {
	Rotation = {
		Front = Vector(0, -2.5, 0),
		Right = Vector(0, 0, 70), -- Rotate towards flying direction
		Top = Vector(0, -20, 0)
	},
	Lift = {
		Front = Vector(0, 0, 20), -- Go up when flying forward
		Right = Vector(0, 0, 0),
		Top = Vector(0, 0, -0.5)
	},
	Rail = Vector(1, 5, 10),
	Drag = {
		Directional = Vector(0.01, 0.01, 0.01),
		Angular = Vector(0.05, 0.2, 0.05)
	}
}