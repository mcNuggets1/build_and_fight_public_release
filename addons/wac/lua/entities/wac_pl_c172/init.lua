
include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function ENT:SpawnFunction(ply, trace)
	if (!trace.Hit) then return end
	local ent = ents.Create(ClassName)
	ent:SetPos(trace.HitPos + trace.HitNormal*60)
	ent.Owner = ply
	ent:Spawn()
	ent:Activate()
	local i = 0
	hook.Add("Think", "", function()
		if i > 66 then return end
		i = i + 1
		if ent == NULL then return end
		ent:SetAngles(Angle(0, 0, 0))
	end)
	return ent
end

function ENT:Initialize()
	self:base("wac_pl_base").Initialize(self)
	self.basePhysicsUpdate = self:base("wac_pl_base").PhysicsUpdate
end

function ENT:PhysicsUpdate(ph)
	self:basePhysicsUpdate(ph)
	local lvel = self:WorldToLocal(self:GetPos() + self:GetVelocity())
	self:GetPhysicsObject():AddAngleVelocity(Vector(
		0, 5-math.Clamp(math.abs(lvel.x)/100, 0, 5), 0
	)*FrameTime()*60)
end