SWEP.Base = "weapon_base"
SWEP.PrintName = "Sans Fähigkeiten"
SWEP.Purpose = "You’re Gonna Have a Bad Time."
SWEP.Instructions = "Linksklick: Schieße die Knochen deiner Feinde.\nRechtsklick: Zünde deine Blaster.\nNachladen: Knochenfalle.\nDucken: Verbessere deine Ausweichfähigkeiten. Verhindert alle Angriffe."
SWEP.Category = "Legendäre Waffen"
SWEP.HoldType = "normal"
SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.DrawCrosshair = true
SWEP.DrawWeaponInfoBox = true
SWEP.BounceWeaponIcon = false
SWEP.ViewModel = Model("models/weapons/c_arms.mdl")
SWEP.WorldModel = Model("models/evangelos/undertale/gasterblaster.mdl")
SWEP.Primary.Automatic = true
SWEP.Secondary.Automatic = true
SWEP.Primary.Ammo = ""
SWEP.Secondary.Ammo = ""
SWEP.IsGun = true

if SERVER then
	util.AddNetworkString("sans_miss")

	local attack = Sound("undertale/attack.wav")
	hook.Add("EntityTakeDamage", "sans_miss", function(ply, dmginfo)
		if ply:IsPlayer() and !ply:InVehicle() then
			local wep = ply:GetActiveWeapon()
			if wep:IsValid() and wep:GetClass() == "weapon_undertale_sans" and (wep.DodgeChance or 0) <= CurTime() then
				local crouching = ply:Crouching() and ply:OnGround()
				local miss = crouching and math.random(1, 2) or math.random(1, 3)
				if miss == 2 then
					net.Start("sans_miss")
						local dmgpos = dmginfo:GetDamagePosition()
						if dmgpos != Vector() then
							net.WriteVector(dmgpos)
						else
							net.WriteVector(ply:EyePos())
						end
					net.Broadcast()
					sound.Play(attack, ply:GetPos())
					return true
				end
			end
		end
	end)
end

if CLIENT then
	local miss = Material("undertale/miss")
	net.Receive("sans_miss", function()
		local vec = net.ReadVector()
		local emitter = ParticleEmitter(vec, false)
		local particle = emitter:Add(miss, vec)
		if particle then
			particle:SetVelocity(Vector(0, 0, 10))
			particle:SetColor(255, 255, 255)
			particle:SetLifeTime(0)
			particle:SetDieTime(2)
			particle:SetStartSize(10)
			particle:SetEndSize(10)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetGravity(Vector(0, 0, 0))
		end
		emitter:Finish()
	end)
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

local theme = Sound("undertale/theme/sans_theme.mp3")
function SWEP:Repeat()
	if CLIENT then return true end
	if self.BeatSound then
		self.BeatSound:Stop()
		self.BeatSound = nil
	end
	local rf = RecipientFilter()
	rf:AddAllPlayers()
	self.BeatSound = CreateSound(self.Owner, theme, rf)
	if self.BeatSound then
		self.BeatSound:Play()
	end
	timer.Create("sans_repeat_"..self:EntIndex(), 155, 1, function()
		if !IsValid(self) then return end
		self:Repeat()
	end)
end

function SWEP:Deploy()
	self:Repeat()
	self.DodgeChance = CurTime() + 1
	return true
end

function SWEP:Equip()
	self:SetVar("blockbone", 0)
end

if CLIENT then
	killicon.Add("weapon_undertale_sans", "undertale/killicon_telekinesis", color_white)
end

function SWEP:KillSounds()
	if CLIENT then return true end
	if self.BeatSound then
		self.BeatSound:Stop()
		self.BeatSound = nil
	end
	timer.Remove("sans_repeat_"..self:EntIndex())
end

function SWEP:Holster()
	self:KillSounds()
	return true
end

function SWEP:OnRemove()
	self:KillSounds()
end

function SWEP:OnDrop()
	self:KillSounds()
end

local gaster_blaster = Sound("undertale/gaster_blaster/gaster_blaster_start.mp3")
function SWEP:PrimaryAttack()
	if CLIENT then return end
	if !IsValid(self.Owner) or self.Owner:WaterLevel() > 2 then return end
	if self.Owner:Crouching() and self.Owner:OnGround() then return end
	self:SetNextPrimaryFire(CurTime() + 0.5)
	self:SetNextSecondaryFire(CurTime() + 0.5)
	local ent = ents.Create("undertale_gaster_blaster")
	if !IsValid(ent) then return end
	local rand = math.Rand(-math.pi, math.pi) / 2
	local vec = Vector(0, math.sin(rand) * 70, 100 + math.cos(rand) * 50)
	vec:Rotate(Angle(0, self.Owner:GetAngles().y, 0))
	local pos = self.Owner:GetPos() + vec
	ent:SetAngles((self.Owner:GetEyeTrace().HitPos - pos):Angle())
	ent:SetPos(self.Owner:GetPos())
	ent:SetOwner(self.Owner)
	ent:SetVar("position", pos)
	ent:EmitSound(gaster_blaster, 100, 100, 1, CHAN_AUTO)
	ent:Spawn()
end

function SWEP:CheckPosition(pos)
	local tr = util.TraceLine({
		start = self.Owner:GetShootPos(),
		endpos = pos,
		mask = MASK_SOLID,
		filter = {self.Owner}
	})
	if tr.Hit then return false, tr end
	return true
end

local bone_end = Sound("undertale/bone_end.wav")
function SWEP:SecondaryAttack()
	if CLIENT then return end
	if !IsValid(self.Owner) or self.Owner:WaterLevel() > 2 then return end
	if self.Owner:Crouching() and self.Owner:OnGround() then return end
	self:SetNextPrimaryFire(CurTime() + 0.3) 
	self:SetNextSecondaryFire(CurTime() + 0.3)
	local ent = ents.Create("undertale_bone_throw")
	if !IsValid(ent) then return end
	local side = self.NextSide or false
	if side then
		self.NextSide = false
		side = 1
	else
		self.NextSide = true
		side = -1
	end
	local pos = self.Owner:GetShootPos() + self.Owner:EyeAngles():Right() * 40 * side
	ent:SetAngles((self.Owner:GetEyeTrace().HitPos - pos):Angle() + Angle(90, 0, 0))
	local check, tr = self:CheckPosition(pos)
	if !check then
		if self.Owner:GetShootPos():DistToSqr(tr.HitPos) <= 10000 then
			ent:SetPos(self.Owner:GetShootPos() + self.Owner:GetForward() * -25)
		else
			ent:SetPos(self.Owner:GetShootPos())
		end
		ent:SetAngles(self.Owner:EyeAngles() + Angle(90, 0, 0))
	else
		ent:SetPos(pos)
	end
	ent:EmitSound(bone_end, 75, 100, 1, CHAN_AUTO)
	ent:SetOwner(self.Owner)
	ent:Spawn()
	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetVelocity(ent:GetUp() * 10000)
	end
end

local bone_start = Sound("undertale/bone_start.wav")
function SWEP:Think()
	if !SERVER then return end
	if self.BeatSound then
		self.BeatSound:ChangeVolume(1, 0.1)
	end
	if self:GetNextPrimaryFire() > CurTime() then return end
	if self:GetNextSecondaryFire() > CurTime() then return end
	if self.Owner:Crouching() and self.Owner:OnGround() then return end
	if (self.Owner:KeyPressed(IN_RELOAD) and self:GetVar("blockbone") == 0) then
		self:SetVar("blockbone", CurTime() + 1.5)
		local tab = ents.FindByClass("undertale_bone*")
		table.insert(tab, self.Owner)
		local tr = util.TraceLine({
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:EyeAngles():Forward() * 10000,
			filter = tab,
			mask = MASK_SHOT_HULL
		})
		local pos = tr.HitPos
		local rad = 30
		sound.Play(bone_start, tr.HitPos)
		for i = 1, 15 do
			local vec = Vector(math.Rand(-rad, rad), math.Rand(-rad, rad), 0)
			vec:Rotate(tr.HitNormal:Angle() + Angle(90, 0, 0))
			local ang = (tr.HitNormal * 2 + VectorRand()):Angle()
			local traceGrd = util.TraceLine({
				start = pos + vec,
				endpos = pos + vec - ang:Up() * 50,
				filter = tab,
				mask = MASK_SHOT_HULL
			})
			if traceGrd.Hit then
				local ent = ents.Create("undertale_bone_ground")
				if !IsValid(ent) then return end
				ent:SetAngles(ang + Angle(90, 0, 0))
				ent:SetVar("pos", pos)
				ent:SetVar("normal", tr.HitNormal)
				ent:SetPos(traceGrd.HitPos)
				ent:SetOwner(self.Owner)
				ent:Spawn()
			end
		end
	end
	if CurTime() > self:GetVar("blockbone") then
		self:SetVar("blockbone", 0)
	end
end

function SWEP:DrawWorldModel()
	if !IsValid(self.Owner) then
		self:DrawModel()
		return
	end
	local pos = Vector()
	local ang = Angle()
	local attach_id = self.Owner:LookupAttachment("eyes")
	if !attach_id then return end
	local attach = self.Owner:GetAttachment(attach_id)
	if !attach then return end
	pos = attach.Pos
	ang = attach.Ang
	local model = ClientsideModel("models/evangelos/undertale/gasterblaster.mdl")
	if !IsValid(model) then return end
	model:SetModelScale(0.5)
	model:SetPos(pos)
	model:SetAngles(ang)
	model:SetRenderOrigin(pos)
	model:SetRenderAngles(ang)
	model:SetupBones()
	model:DrawModel()
	model:SetRenderOrigin()
	model:SetRenderAngles()
	model:Remove()
end