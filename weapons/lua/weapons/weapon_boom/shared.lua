if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.PrintName = "Erectin' A BOOM"
SWEP.DrawCrosshair = false
SWEP.Author = "Modern Gaming"
SWEP.Purpose = "Linksklick, um Dubstepmusik abzuspielen und Spieler/NPCs in die Luft zu jagen."
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/props_lab/citizenradio.mdl"
SWEP.WorldModel = Model("models/props_lab/citizenradio.mdl")
SWEP.BobScale = 4.5
SWEP.SwayScale = 0
SWEP.Category = "Legendäre Waffen"
SWEP.Slot = 4
SWEP.SlotPos = 5
SWEP.Primary.Damage = 14
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.ViewModelDefPos = Vector(-11.9885, -45.7463, -22.2584)
SWEP.ViewModelDefAng = Vector(-178.6234, 7.6472, 176.4833)
SWEP.MoveToPos = Vector(-15.2644, -44.5813, -24.8858)
SWEP.MoveToAng = Vector(-179.1521, 5.1085, 168.4864)
SWEP.Sound = Sound("erectriver.mp3")
SWEP.HoldType = "normal"
SWEP.Volume = 0
SWEP.Influence = 0
SWEP.LastSoundRelease = 0
SWEP.RestartDelay = 1
SWEP.RandomEffectsDelay = 0.2
SWEP.OverwriteMulti = 1
SWEP.FixOverwrite = 0
SWEP.IsGun = true

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Activated")
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
	self:SlowAnimation()
	self.BaseClass.Deploy(self)
	self:CallOnClient("Deploy")
	return true
end

function SWEP:SlowAnimation()
	self.OverwriteMulti = 3
	self.FixOverwrite = CurTime() + self.RestartDelay
	self.Volume = 3
	self.LastSoundRelease = CurTime()
end

function SWEP:CreateSound()
	self.SoundObject = CreateSound(self, self.Sound)
	self.SoundObject:Play()
end

function SWEP:Holster()
	self:EndSound()
  	return true
end

function SWEP:OnRemove()
	self:EndSound()
end

function SWEP:OnDrop()
	self:EndSound()
end

function SWEP:EndSound()
	if self.SoundObject then
		self.SoundObject:Stop()
	end
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:GetViewModelPosition (pos, ang, inv, mul)
	if self.FixOverwrite < CurTime() then
		self.OverwriteMulti = 1
	end
	local mul = 0
	if self:GetActivated() then
		self.Volume = math.Clamp(self.Volume + RealFrameTime() * 3, 0, self.OverwriteMulti)
	else
		self.Volume = math.Clamp(self.Volume - RealFrameTime() * 3, 0, self.OverwriteMulti)
	end
	mul = self.Volume
	local DefPos = self.ViewModelDefPos
	local DefAng = self.ViewModelDefAng
	if DefAng then
		ang = ang * 1
		ang:RotateAroundAxis(ang:Right(), DefAng.x)
		ang:RotateAroundAxis(ang:Up(), DefAng.y)
		ang:RotateAroundAxis(ang:Forward(), DefAng.z)
	end
	if DefPos then
		local Right = ang:Right()
		local Up = ang:Up()
		local Forward = ang:Forward()
		pos = pos + DefPos.x * Right
		pos = pos + DefPos.y * Forward
		pos = pos + DefPos.z * Up
	end
	local AddPos = self.MoveToPos - self.ViewModelDefPos
	local AddAng = self.MoveToAng - self.ViewModelDefAng
	if AddAng then
		ang = ang * 1
		ang:RotateAroundAxis(ang:Right(), AddAng.x * mul)
		ang:RotateAroundAxis(ang:Up(), AddAng.y * mul)
		ang:RotateAroundAxis(ang:Forward(), AddAng.z * mul)
	end
	if AddPos then
		local Right = ang:Right()
		local Up = ang:Up()
		local Forward = ang:Forward()
		pos = pos + AddPos.x * Right * mul
		pos = pos + AddPos.y * Forward * mul
		pos = pos + AddPos.z * Up * mul
	end
	return pos, ang
end

if !SERVER then return end

function SWEP:Think()
	local owner = self:GetOwner()
	local tb = self:GetTable()
	tb.LastFrame = self.LastFrame or CurTime()
	tb.LastRandomEffects = tb.LastRandomEffects or 0
	if owner:KeyDown(IN_ATTACK) and tb.LastSoundRelease + tb.RestartDelay < CurTime() then
		if !tb.SoundObject then
			self:CreateSound()
		end
		tb.Volume = math.Clamp(tb.Volume + CurTime() - tb.LastFrame, 0, 1)
		tb.Influence = math.Clamp(tb.Influence + (CurTime() - tb.LastFrame) / 2, 0, 1)
		tb.SoundObject:ChangeVolume(tb.Volume, 0)
		tb.SoundPlaying = true
	else
		if tb.SoundObject and tb.SoundPlaying then
			tb.SoundObject:ChangeVolume(0, 0.5)
			tb.SoundPlaying = false
			tb.LastSoundRelease = CurTime()
			tb.Volume = 0
			tb.Influence = 0
		end
	end
	tb.LastFrame = CurTime()
	self:SetActivated(tb.SoundPlaying)
	if tb.Influence > 0.5 and tb.LastRandomEffects + tb.RandomEffectsDelay < CurTime() then
		for _, ent in ipairs(ents.FindInSphere(owner:GetPos(), 200)) do
			if ent:IsPlayer() and ent:Alive() and owner != ent or ent:IsNPC() or ent:Health() > 0 then
				if ent:GetNoDraw() or !ent:IsSolid() then continue end
				local vec1 = ((ent.GetShootPos and ent:GetShootPos() or ent:GetPos()) - owner:GetShootPos())
				vec1:Normalize()
				local dot = vec1:DotProduct(owner:GetAimVector())
				if dot > 0.5 then
					local tr = util.TraceLine({
						start = owner:GetShootPos(),
						endpos = ent.GetShootPos and ent:GetShootPos() or ent:GetPos(),
						filter = {owner, ent}
					})
					if IsValid(tr.Entity) and tr.Entity != ent then continue end
					local pos = ent:GetPos()
					util.BlastDamage(self, owner, pos, 25, self.Primary.Damage * math.Rand(0.75, 1.25))
					util.ScreenShake(pos, 256, 255, 1, 75)
					local edata = EffectData()
					edata:SetOrigin(pos)
					util.Effect("Explosion", edata, true, true)
					util.Decal("Scorch", pos, pos - Vector(0, 0, 50), {owner, ent})
				end
			end
		end
		tb.LastRandomEffects = CurTime()
	end
end