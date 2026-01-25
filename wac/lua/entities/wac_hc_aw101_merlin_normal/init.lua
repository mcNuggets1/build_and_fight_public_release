
include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")


ENT.Submersible	= false
ENT.UsePhysRotor = true
ENT.RotorWidth		= 0
ENT.MaxEnterDistance	= 100
ENT.EngineForce		= 58
ENT.Weight			= 46000
ENT.BrakeMul = 1
ENT.AngBrakeMul	= 0.01

ENT.Wheels={
	{
		mdl="models/hypno/aw101/normal/aw101_rtwheel.mdl",
		pos=Vector(251,-8,9.25),
		friction=100,
		mass=1500,
	},
	{
		mdl="models/hypno/aw101/normal/aw101_lfwheel.mdl",
		pos=Vector(251,8,9.25),
		friction=100,
		mass=1500,
	},
	{
		mdl="models/hypno/aw101/normal/aw101_rtwheel.mdl",
		pos=Vector(-65.4,-86.5,14.5),
		friction=100,
		mass=1500,
	},
	{
		mdl="models/hypno/aw101/normal/aw101_lfwheel.mdl",
		pos=Vector(-65.4,86.5,14.5),
		friction=100,
		mass=1500,
	},
	{
		mdl="models/hypno/aw101/normal/aw101_lfwheel.mdl",
		pos=Vector(-65.4,-71,14.5),
		friction=100,
		mass=1500,
	},
	{
		mdl="models/hypno/aw101/normal/aw101_rtwheel.mdl",
		pos=Vector(-65.4,71,14.5),
		friction=100,
		mass=1500,
	},
}

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then return end
	local ent=ents.Create(ClassName)
	ent:SetPos(tr.HitPos+tr.HitNormal*30)
	ent.Owner=ply
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:PhysicsUpdate(ph)
	self:base("wac_hc_base").PhysicsUpdate(self,ph)
	
	local phys=self:GetPhysicsObject()
	if IsValid(phys) and not self.disabled then
		if phys:GetVelocity():Length() > 850 then
			self:SetBodygroup(1,1)
		else
			self:SetBodygroup(1,0)
		end
	end
end


