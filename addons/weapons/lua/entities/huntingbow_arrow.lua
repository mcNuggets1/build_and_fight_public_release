if SERVER then
	AddCSLuaFile()
end

ENT.Type = "anim"
ENT.Spawnable = false
ENT.Model = Model("models/weapons/w_huntingbow_arrow.mdl")

local ARROW_MINS = Vector(-0.5, -0.5, 0.5)
local ARROW_MAXS = Vector(0.5, 0.5, 0.5)
function ENT:Initialize()
	if SERVER then
		self:SetModel(self.Model)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_FLYGRAVITY)
		self:SetSolid(SOLID_BBOX)
		self:SetCollisionBounds(ARROW_MINS, ARROW_MAXS)
		self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
		end
		self:SetTrigger(true)
		self.Trail = util.SpriteTrail(self, 0, color_white, true, 3, 0.5, 1, 1 / 3 * 0.5, "trails/laser.vmt")
	end
end

function ENT:Think()
	if SERVER then
		if self:GetMoveType() == MOVETYPE_FLYGRAVITY then
			self:SetAngles(self:GetVelocity():Angle())
		end
	end
end

local StickSound = {
	Sound("weapons/huntingbow/impact_arrow_stick_1.wav"),
	Sound("weapons/huntingbow/impact_arrow_stick_2.wav"),
	Sound("weapons/huntingbow/impact_arrow_stick_3.wav")
}

local FleshSound = {
	Sound("weapons/huntingbow/impact_arrow_flesh_1.wav"),
	Sound("weapons/huntingbow/impact_arrow_flesh_2.wav"),
	Sound("weapons/huntingbow/impact_arrow_flesh_3.wav"),
	Sound("weapons/huntingbow/impact_arrow_flesh_4.wav")
}

function ENT:Touch(ent)
	if self:GetOwner() == ent then return end
	if ent:GetClass() == "func_button" then return end -- ToDo: Make a proper fix.
	local vel = self:GetVelocity()
	local speed = vel:Length()
	local tr = self:GetTouchTrace()
	if ent:IsWorld() then
		sound.Play(StickSound[math.random(1, #StickSound)], tr.HitPos)
		self:SetMoveType(MOVETYPE_NONE)
		self:PhysicsInit(SOLID_NONE)
		SafeRemoveEntityDelayed(self, 10)
		return
	end
	if IsValid(ent) then
		if !ent:GetSolid() then return end
		if ent:IsPlayer() or ent:IsRagdoll() or ent:IsNPC() then
			local edata = EffectData()
			edata:SetOrigin(tr.HitPos)
			util.Effect("BloodImpact", edata, true, true)
			sound.Play(FleshSound[math.random(1, #FleshSound)], tr.HitPos)
			self:Remove()
		else
			self:SetParent(ent)
			sound.Play(StickSound[math.random(1, #StickSound)], tr.HitPos)
			self:SetMoveType(MOVETYPE_NONE)
			self:SetSolid(SOLID_NONE)
			SafeRemoveEntity(self.Trail)
			SafeRemoveEntityDelayed(self, 10)
		end
		local damage = math.floor(math.Clamp(speed / 20, 50, 150))
		ent:TakeDamage(damage, self:GetOwner(), self)
		ent:Fire("Shatter")
	end
end