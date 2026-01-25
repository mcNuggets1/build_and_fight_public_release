AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Model = Model("models/bshields/rshield.mdl")
ENT.Mass = 100

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetRenderMode(RENDERMODE_TRANSCOLOR)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetMass(self.Mass)
	end
end

function ENT:ColorShield()
	self:SetColor(Color(255, (self:Health() / self.MaxHP) * 255, (self:Health() / self.MaxHP) * 255))
end

function ENT:OnTakeDamage(dmg)
	self:SetHealth(self:Health() - dmg:GetDamage())
	self:ColorShield()
	if self:Health() < 0 and !self.Destroyed then
		self.Destroyed = true
		local edata = EffectData()
		edata:SetOrigin(self:GetPos())
		util.Effect("cball_explode", edata, true, true)
		self:EmitSound("physics/metal/metal_box_break1.wav")
		local ply = self:GetParent()
 		if IsValid(ply) and ply:IsPlayer() then
			ply:StripWeapon("weapon_riot_shield")
			ply:ConCommand("lastinv")
		end
		self:Remove()
	end
end