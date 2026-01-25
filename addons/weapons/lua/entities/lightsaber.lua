if SERVER then
	AddCSLuaFile()
end

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Lichtschwert"
ENT.Category = "Fun + Games"

ENT.Editable = true
ENT.Spawnable = true

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "BladeLength")
	self:NetworkVar("Float", 1, "BladeWidth", {KeyName = "Klingendicke", Edit = {type = "Float", category = "Klinge", min = 2, max = 4, order = 1}})
	self:NetworkVar("Float", 2, "MaxLength", {KeyName = "Klingenlänge", Edit = {type = "Float", category = "Klinge", min = 32, max = 64, order = 2}})
	self:NetworkVar("Bool", 0, "Enabled")
	self:NetworkVar("Bool", 1, "DarkInner", {KeyName = "Dunkel innere Klinge", Edit = {type = "Boolean", category = "Klinge", order = 3}})
	self:NetworkVar("Vector", 0, "CrystalColor", {KeyName = "Kristallfarbe", Edit = {type = "VectorColor", category = "Griff", order = 4}})
	if SERVER then
		self:SetBladeLength(0)
		self:SetBladeWidth(2)
		self:SetMaxLength(42)
		self:SetDarkInner(false)
		self:SetEnabled(true)
	end
end

function ENT:Initialize()
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self.LoopSound = self.LoopSound or "lightsaber/saber_loop"..math.random(1, 8)..".wav"
		self.SwingSound = self.SwingSound or "lightsaber/saber_swing"..math.random(1, 2)..".wav"
		self.OnSound = self.OnSound or "lightsaber/saber_on"..math.random(1, 2)..".wav"
		self.OffSound = self.OffSound or "lightsaber/saber_off"..math.random(1, 2)..".wav"
		if self:GetEnabled() then
			self:EmitSound(self.OnSound)
		end
		self.SoundSwing = CreateSound(self, Sound(self.SwingSound))
		if self.SoundSwing then
			self.SoundSwing:Play()
			self.SoundSwing:ChangeVolume(0, 0)
		end
		self.SoundHit = CreateSound(self, Sound("lightsaber/saber_hit.wav"))
		if self.SoundHit then
			self.SoundHit:Play()
			self.SoundHit:ChangeVolume(0, 0)
		end
		self.SoundLoop = CreateSound(self, Sound(self.LoopSound))
		if self.SoundLoop then
			self.SoundLoop:Play()
		end
	else
		self:SetRenderBounds(Vector(-self:GetBladeLength(), -128, -128), Vector(self:GetBladeLength(), 128, 128))
		language.Add(self.ClassName, self.PrintName)
		killicon.AddAlias("lightsaber", "weapon_lightsaber")
	end
end

function ENT:OnRemove()
	if CLIENT then LS_SaberClean(self:EntIndex()) return end
	if self.SoundLoop then self.SoundLoop:Stop() self.SoundLoop = nil end
	if self.SoundSwing then self.SoundSwing:Stop() self.SoundSwing = nil end
	if self.SoundHit then self.SoundHit:Stop() self.SoundHit = nil end
	if self:GetEnabled() then self:EmitSound(self.OffSound) end
end

function ENT:GetSaberPosAng(num)
	num = num or 1
	local attachment = self:LookupAttachment("blade"..num)
	if (attachment > 0) then
		local PosAng = self:GetAttachment(attachment)
		return PosAng.Pos, PosAng.Ang:Forward()
	end
	return self:LocalToWorld(Vector(1, -0.58, -0.25)), -self:GetAngles():Forward()
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	if (halo.RenderedEntity and IsValid(halo.RenderedEntity()) and halo.RenderedEntity() == self) then return end
	local clr = self:GetCrystalColor() * 255
	clr = Color(clr.x, clr.y, clr.z)
	local pos, ang = self:GetSaberPosAng()
	LS_RenderBlade(self, pos, ang, self:GetBladeLength(), self:GetMaxLength(), self:GetBladeWidth(), clr, self:GetDarkInner(), self:EntIndex(), self:WaterLevel() > 2)
	if (self:LookupAttachment("blade2") > 0) then
		local pos, ang = self:GetSaberPosAng(2)
		LS_RenderBlade(self, pos, ang, self:GetBladeLength(), self:GetMaxLength(), self:GetBladeWidth(), clr, self:GetDarkInner(), self:EntIndex() + 655, self:WaterLevel() > 2)
	end
end

if !SERVER then return end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)
end

function ENT:Think()
	if (!self:GetEnabled() and self:GetBladeLength() != 0) then
		self:SetBladeLength(math.Approach(self:GetBladeLength(), 0, 2))
	elseif (self:GetEnabled() and self:GetBladeLength() != self:GetMaxLength()) then
		self:SetBladeLength(math.Approach(self:GetBladeLength(), self:GetMaxLength(), 8))
	end
	if (self:GetBladeLength() <= 0) then
		if self.SoundSwing then
			self.SoundSwing:ChangeVolume(0, 0)
		end
		if self.SoundLoop then
			self.SoundLoop:ChangeVolume(0, 0)
		end
		if self.SoundHit then
			self.SoundHit:ChangeVolume(0, 0)
		end
		return
	end
	local pos, ang = self:GetSaberPosAng()
	local hit = self:BladeThink(pos, ang)
	if (self:LookupAttachment("blade2") > 0) then
		local pos2, ang2 = self:GetSaberPosAng(2)
		local hit_2 = self:BladeThink(pos2, ang2)
		hit = hit or hit_2
	end
	if self.SoundHit then
		if hit then
			self.SoundHit:ChangeVolume(math.Rand(0.1, 0.5), 0)
		else
			self.SoundHit:ChangeVolume(0, 0)
		end
	end
	if self.SoundSwing then
		if (self.LastAng != ang) then
			self.LastAng = self.LastAng or ang
			self.SoundSwing:ChangeVolume(math.Clamp(ang:DistToSqr(self.LastAng) / (2*2), 0, 1), 0)
		end
		self.LastAng = ang
	end
	if self.SoundLoop then
		local pos = pos + ang * self:GetBladeLength()
		if (self.LastPos != pos) then
			self.LastPos = self.LastPos or pos
			self.SoundLoop:ChangeVolume(0.1 + math.Clamp(pos:DistToSqr(self.LastPos) / (32*32), 0, 0.2), 0)
		end
		self.LastPos = pos
	end
	self:NextThink(CurTime())
	return true
end

function ENT:BladeThink(startpos, dir)
	local trace = util.TraceHull({start = startpos,endpos = startpos + dir * self:GetBladeLength(),filter = self})
	if trace.Hit then
		LS_DrawHit(trace.HitPos, trace.HitNormal)
		LS_DoDamage(trace, self)
	end
	return trace.Hit
end

function ENT:Use(activator, caller, useType, value)
	if (!IsValid(activator) or !activator:KeyPressed(IN_USE)) then return end
	if self:GetEnabled() then
		self:EmitSound(self.OffSound)
	else
		self:EmitSound(self.OnSound)
	end
	self:SetEnabled(!self:GetEnabled())
end

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit or !ply:CheckLimit("lightsabers")) then return end
	local ent = ents.Create(ClassName)
	ent:SetPos(tr.HitPos + tr.HitNormal * 2)
	local ang = ply:EyeAngles()
	ang.p = 0
	ang:RotateAroundAxis(ang:Right(), 180)
	ent:SetAngles(ang)
	ent:SetMaxLength(math.Clamp(ply:GetInfoNum("lightsaber_bladel", 42), 32, 64))
	ent:SetCrystalColor(Vector(ply:GetInfo("lightsaber_red"), ply:GetInfo("lightsaber_green"), ply:GetInfo("lightsaber_blue")) / 255)
	ent:SetDarkInner(ply:GetInfo("lightsaber_dark") == "1")
	ent:SetModel(ply:GetInfo("lightsaber_model"))
	ent:SetBladeWidth(math.Clamp(ply:GetInfoNum("lightsaber_bladew", 2), 2, 4))
	ent.LoopSound = ply:GetInfo("lightsaber_humsound")
	ent.SwingSound = ply:GetInfo("lightsaber_swingsound")
	ent.OnSound = ply:GetInfo("lightsaber_onsound")
	ent.OffSound = ply:GetInfo("lightsaber_offsound")
	ent:Spawn()
	ent:Activate()
	ent.Owner = ply
	ent.Color = ent:GetColor()
	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
	if IsValid(ply) then
		ply:AddCount("lightsabers", ent)
		ply:AddCleanup("lightsabers", ent)
	end
	return ent
end