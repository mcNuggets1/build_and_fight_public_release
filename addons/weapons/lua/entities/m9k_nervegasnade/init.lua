AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self.lifetime = CurTime() + 45
	self:SetModel("models/healthvial.mdl")
	self:SetMaterial("models/weapons/gv/nerve_vial.vmt")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(4)
		phys:Wake()
	end
end

local bottle_break = Sound("GlassBottle.Break")
function ENT:Think()
	if !IsValid(self.Owner) then
		self:Remove()
		return
	end
	if CurTime() > self.lifetime then
		self:EmitSound(bottle_break)
		self:BreakVial()
		return
	end
	self:NextThink(CurTime())
	return true
end

function ENT:PhysicsCollide(data, phys)
	if data.HitEntity:IsWorld() then
		local tr = util.TraceLine({
			start = data.HitPos,
			endpos = data.HitPos + data.HitNormal,
			filter = self
		})
		if tr.HitSky then return end
	end
	if data.Speed > 50 then
		self:EmitSound(bottle_break)
		self:BreakVial()
	end
end

function ENT:BreakVial()
	if self.Broken then return end
	self.Broken = true
	local pos = self:GetPos()
	timer.Simple(0, function()
		if !IsValid(self) then return end
		local gas = ents.Create("m9k_released_gas")
		if !IsValid(gas) then return end
		gas:SetPos(pos)
		gas:SetOwner(self.Owner)
		gas.Owner = self.Owner
		gas:Spawn()
		self:Remove()
	end)
end

function ENT:OnTakeDamage(dmginfo)
	self:EmitSound(bottle_break)
	self:BreakVial()
end