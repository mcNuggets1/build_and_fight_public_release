if SERVER then
	AddCSLuaFile()
end

CreateConVar("lightsaber_infinite", 0, {FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE})

SWEP.PrintName = "Lichtschwert"
SWEP.Category = "Legendäre Waffen"
SWEP.DrawWeaponInfoBox = true
SWEP.Purpose = "Es werden Köpfe rollen."
SWEP.Instructions = "Die Macht ist mit dir."
SWEP.RenderGroup = RENDERGROUP_BOTH
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.Spawnable = true
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = Model("models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl")
SWEP.ViewModelFOV = 55
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.IsGun = true

function SWEP:PlayWeaponSound(snd)
	if CLIENT or !IsValid(self:GetOwner()) then return end
	self:GetOwner():EmitSound(snd)
end

function SWEP:SelectTargets(num)
	local owner = self:GetOwner()
	local shootPos = owner:GetShootPos()
	local t = {}
	local dist = 200
	local tr = util.TraceLine({start = shootPos, endpos = shootPos + owner:GetAimVector() * dist, filter = owner})
	local p = {}
	for _, ply in ipairs(ents.FindInSphere(shootPos, dist)) do
		local model = ply:GetModel()
		if (!model or model == "" or ply == owner or ply:Health() <= 0) then continue end
		local tr = util.TraceLine({start = shootPos, endpos = (ply.GetShootPos and ply:GetShootPos() or ply:GetPos()), filter = owner})
		if (tr.Entity != ply and IsValid(tr.Entity)) then continue end
		local pos1 = owner:GetPos() + owner:GetAimVector() * dist
		local pos2 = ply:GetPos()
		table.insert(p, {ply = ply, dist = pos1:Distance(pos2)})
	end
	local d = {}
	for _, ply in SortedPairsByMemberValue(p, "dist") do
		table.insert(t, ply.ply)
		if (#t >= num) then return t end
	end
	return t
end

if SERVER then
	concommand.Add("select_force", function(ply, cmd, args)
		if (!IsValid(ply) or !ply:GetActiveWeapon():IsValid() or ply:GetActiveWeapon():GetClass() != "weapon_lightsaber" or !tonumber(args[1])) then return end
		local wep = ply:GetActiveWeapon()
		local typ = math.Clamp(tonumber(args[1]), 1, #wep.ForcePowers)
		wep:SetForceType(typ)
	end)
end

hook.Add("EntityTakeDamage", "lightsaber_no_fall_damage", function(ply, dmg)
	if (ply:IsPlayer() and ply:GetActiveWeapon():IsValid() and ply:GetActiveWeapon():GetClass() == "weapon_lightsaber" and dmg:IsFallDamage()) then
		if ply:KeyDown(IN_DUCK) then
			ply:SetNW2Float("SWLS_FeatherFall", CurTime())
			local wep = ply:GetActiveWeapon()
			wep:SetNextAttack(0.5)
			local damage = dmg:GetDamage()
			ply:ViewPunch(Angle(damage / 6, 0, math.random(-damage, damage) / 24))
			return true
		end
	end
end)

function SWEP:OnRestore()
	self:GetOwner():SetNW2Float("SWLS_FeatherFall", 0)
end

local local_ply, cur_time
local function lighsaber_no_fall_damage(cmd)
	local_ply = local_ply or LocalPlayer()
	cur_time = CurTime()
	if (cur_time - local_ply:GetNW2Float("SWLS_FeatherFall", cur_time - 2) < 1) then
		cmd:ClearButtons()
		cmd:ClearMovement()
		cmd:SetButtons(IN_DUCK)
	end
end
hook.Add("CreateMove", "lightsaber_no_fall_damage", lighsaber_no_fall_damage)

hook.Add("EntityTakeDamage", "lightsabers_armor", function(ply, dmg)
	if !ply:IsPlayer() then return end
	local wep = ply:GetActiveWeapon()
	if (!wep:IsValid() or wep:GetClass() != "weapon_lightsaber" or wep.ForcePowers[wep:GetForceType()].name != "Absolvierungskraft") then return end
	if !ply:KeyDown(IN_ATTACK2) then return end
	local damage = dmg:GetDamage() / 4
	local force = wep:GetForce()
	if (force < damage) then
		wep:SetForce(0)
		dmg:SetDamage((damage - force) * 4)
		return
	end
	wep:SetForce(force - damage)
	dmg:SetDamage(damage)
end)

function SWEP:SetNextAttack(delay, swinging)
	self:SetNextPrimaryFire(CurTime() + delay)
	self:SetNextSecondaryFire(CurTime() + delay)
	if !SERVER then return end
	self.Swinging = true
	timer.Simple(delay, function()
		if !IsValid(self) then return end
		self.Swinging = nil
	end)
end

function SWEP:ForceJumpAnim()
	self:GetOwner().m_bJumping = true
	self:GetOwner().m_bFirstJumpFrame = true
	self:GetOwner().m_flJumpStartTime = CurTime()
	self:GetOwner():AnimRestartMainSequence()
end

local force_leap = Sound("lightsaber/force_leap.wav")
local force_repulse = Sound("lightsaber/force_repulse.wav")
SWEP.ForcePowers = {
	{
		name = "Kraftsprung",
		icon = "S",
		description = "Springe höher und weiter.\nRichte deinen Blick nach oben um höher zu springen.\nDrücke STRG um Fallschaden zu minimieren, dafür aber\ndeine Bewegung für 1 Sekunde zwangs zu stoppen.",
		action = function(self)
			if (self:GetForce() < 100 or !self:GetOwner():IsOnGround() or CLIENT) then return end
			self:SetForce(self:GetForce() - 100)
			self:SetNextAttack(1.5)
			self:GetOwner():SetVelocity(self:GetOwner():EyeAngles():Forward() * 384 + Vector(0, 0, 384))
			self:PlayWeaponSound(force_leap)
			self:CallOnClient("ForceJumpAnim", "")
		end
	}, {
		name = "Absolvierungskraft",
		icon = "A",
		description = "Halte die rechte Maustaste gedrückt um Schaden zu absolvieren.",
		action = function(self)
			if (self:GetForce() < 5 or CLIENT) then return end
			self:SetForce(self:GetForce() - 5)
			self:SetNextAttack(0.25)
			local ed = EffectData()
			ed:SetOrigin(self:GetOwner():GetPos() + Vector(0, 0, 36))
			ed:SetRadius(32)
			util.Effect("force_repulse_out", ed, true, true)
		end
	}, {
		name = "Kraftrepuls",
		icon = "R",
		description = "Stoße alle Objekte in deiner unmittelbaren Umgebung kilometerweit weg.\nHalte die rechte Maustaste für eine enormere Wirkung.",
		think = function(self)
			if (self:GetNextSecondaryFire() > CurTime()) then return end
			if (self:GetForce() < 1 or CLIENT) then return end
			if (!self:GetOwner():KeyDown(IN_ATTACK2) and !self:GetOwner():KeyReleased(IN_ATTACK2)) then return end
			if (!self._ForceRepulse and self:GetForce() < 25) then return end
			if !self:GetOwner():KeyReleased(IN_ATTACK2) then
				if !self._ForceRepulse then
					self:SetForce(math.max(self:GetForce() - 25, 0))
					self._ForceRepulse = 1
				end
				if (!self.NextForceEffect or self.NextForceEffect < CurTime()) then
					local ed = EffectData()
					ed:SetOrigin(self:GetOwner():GetPos() + Vector(0, 0, 36))
					ed:SetRadius(128 * self._ForceRepulse)
					util.Effect("force_repulse_in", ed, true, true)
					self.NextForceEffect = CurTime() + math.Clamp(self._ForceRepulse / 20, 0.1, 0.5)
				end
				self._ForceRepulse = self._ForceRepulse + 0.025
				self:SetForce(math.max(self:GetForce() - 0.5, 0))
				if (self:GetForce() > 0.99) then return end
			else
				if !self._ForceRepulse then return end
			end
			local maxdist = 128 * self._ForceRepulse
			for i, e in ipairs(ents.FindInSphere(self:GetOwner():GetPos(), maxdist)) do
				if (e == self:GetOwner()) or !e:IsSolid() then continue end
				local dist = self:GetOwner():GetPos():Distance(e:GetPos())
				local mul = (maxdist - dist) / 256
				local v = (self:GetOwner():GetPos() - e:GetPos()):GetNormalized()
				v.z = 0
				if (e:IsNPC() and util.IsValidRagdoll(e:GetModel() or "")) then
					local dmg = DamageInfo()
					dmg:SetDamagePosition(e:GetPos() + e:OBBCenter())
					dmg:SetDamage(48 * mul)
					dmg:SetDamageType(DMG_GENERIC)
					if ((1 - dist / maxdist) > 0.8) then
						dmg:SetDamageType(DMG_DISSOLVE)
						dmg:SetDamage(e:Health() * 3)
					end
					dmg:SetDamageForce(-v * math.min(mul * 60000, 80000))
					dmg:SetInflictor(self:GetOwner())
					dmg:SetAttacker(self:GetOwner())
					e:TakeDamageInfo(dmg)
					e:SetVelocity(v * mul * -4198 + Vector(0, 0, 64))
				elseif e:IsPlayer() then
					e:SetVelocity(v * mul * -4198 + Vector(0, 0, 64))
				elseif (e:GetPhysicsObjectCount() > 0) then
					for i = 0, e:GetPhysicsObjectCount() - 1 do
						e:GetPhysicsObjectNum(i):ApplyForceCenter(v * mul * -512 * math.min(e:GetPhysicsObject():GetMass(), 256) + Vector(0, 0, 64))
					end
				end
			end
			local ed = EffectData()
			ed:SetOrigin(self:GetOwner():GetPos() + Vector(0, 0, 36))
			ed:SetRadius(maxdist)
			util.Effect("force_repulse_out", ed, true, true)
			self._ForceRepulse = nil
			self:SetNextAttack(1)
			self:PlayWeaponSound(force_repulse)
		end
	}, {
		name = "Heilungskraft",
		icon = "H",
		description = "Halte die rechte Maustaste um deine Leben langsam zu regenerieren.",
		action = function(self)
			if (self:GetForce() < 1 or self:GetOwner():Health() >= self:GetOwner():GetMaxHealth() or CLIENT) then return end
			self:SetForce(self:GetForce() - 1)
			self:SetNextAttack(0.45)
			local ed = EffectData()
			ed:SetOrigin(self:GetOwner():GetPos())
			util.Effect("force_heal", ed, true, true)
			self:GetOwner():SetHealth(self:GetOwner():Health() + 1)
		end
	}, {
		name = "Verbrennungskraft",
		icon = "V",
		target = 1,
		description = "Zünde mit der rechten Maustaste Spieler in Front von dir an.",
		action = function(self)
			if CLIENT then return end
			local ent = self:SelectTargets(1)[1]
			if !IsValid(ent) then self:SetNextAttack(0.2) return end
			if (self:GetForce() < 10) then return end
			ent:Ignite(3, 15)
			self:SetForce(self:GetForce() - 10)
			self:SetNextAttack(1)
		end
	}, {
		name = "Kraftsturm",
		icon = "S",
		target = 3,
		description = "Quäle Ziele indem du die rechte Maustaste gedrückt hälst.",
		action = function(self)
			if CLIENT or (self:GetForce() < 1) then return end
			local foundents = 0
			for _, ent in pairs(self:SelectTargets(3)) do
				if !IsValid(ent) then continue end
				foundents = foundents + 1
				local ed = EffectData()
				ed:SetOrigin(self:GetSaberPosAng())
				ed:SetEntity(ent)
				util.Effect("force_lighting", ed, true, true)
				local dmg = DamageInfo()
				dmg:SetAttacker(self:GetOwner() and IsValid(self:GetOwner()) and self:GetOwner() or self)
				dmg:SetInflictor(self:GetOwner() and IsValid(self:GetOwner()) and self:GetOwner() or self)
				dmg:SetDamage(3)
				ent:TakeDamageInfo(dmg)
			end
			if (foundents > 0) then
				self:PlayWeaponSound(force_leap)
				self:SetForce(math.max(self:GetForce() - math.ceil(foundents * 1), 0))
			end
			self:SetNextAttack(0.3)
		end
	}
}

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "BladeLength")
	self:NetworkVar("Float", 1, "MaxLength")
	self:NetworkVar("Float", 2, "BladeWidth")
	self:NetworkVar("Float", 3, "Force")
	self:NetworkVar("Bool", 0, "DarkInner")
	self:NetworkVar("Bool", 1, "Enabled")
	self:NetworkVar("Int", 0, "ForceType")
	self:NetworkVar("Vector", 0, "CrystalColor")
	self:NetworkVar("String", 0, "WorldModel")
	self:NetworkVar("String", 1, "OnSound")
	self:NetworkVar("String", 2, "OffSound")
	if SERVER then
		self:SetBladeLength(0)
		self:SetBladeWidth(2)
		self:SetMaxLength(42)
		self:SetDarkInner(false)
		self:SetEnabled(true)
		self:SetOnSound("lightsaber/saber_on"..math.random(1, 4)..".wav")
		self:SetOffSound("lightsaber/saber_off"..math.random(1, 4)..".wav")
		self:SetWorldModel("models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl")
		self:SetCrystalColor(Vector(math.random(0, 255), math.random(0, 255), math.random(0, 255)))
		self:SetForceType(1)
		self:SetForce(100)
		self:NetworkVarNotify("Force", self.OnForceChanged)
	end
end

function SWEP:Initialize()
	self.LoopSound = self.LoopSound or "lightsaber/saber_loop"..math.random(1, 8)..".wav"
	self.SwingSound = self.SwingSound or "lightsaber/saber_swing"..math.random(1, 2)..".wav"
	self:SetWeaponHoldType(self:GetTargetHoldType())
end

function SWEP:PrimaryAttack()
	if !IsValid(self:GetOwner()) then return end
	self:SetNextAttack(0.5, true)
	if self:GetEnabled() then
		self:GetOwner():AnimResetGestureSlot(GESTURE_SLOT_CUSTOM)
		self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	end
end

function SWEP:SecondaryAttack()
	if (!IsValid(self:GetOwner()) or !self.ForcePowers[self:GetForceType()]) then return end
	local forcePower = self.ForcePowers[self:GetForceType()].name
	local bool = hook.Run("CanUseLightsaberForcePower", self:GetOwner(), forcePower)
	if (bool == false) then return end
	if self.ForcePowers[self:GetForceType()].action then
		self.ForcePowers[self:GetForceType()].action(self)
		if (GetConVar("lightsaber_infinite"):GetInt() != 0) then
			self:SetForce(100)
		end
	end
end

function SWEP:Reload()
	if !IsValid(self:GetOwner()) or !self:GetOwner():KeyPressed(IN_RELOAD) then return end
	if self:GetEnabled() then
		self:PlayWeaponSound(self:GetOffSound())
		if (self:GetOwner():WaterLevel() > 1) then
			self:SetHoldType("knife")
		end
		timer.Create("ls_ht", 0.4, 1, function()
			if IsValid(self) then
				self:SetHoldType("normal")
			end
		end)
		if !SERVER then return end
		if self.SoundLoop then
			self.SoundLoop:Stop()
			self.SoundLoop = nil
		end
		if self.SoundSwing then
			self.SoundSwing:Stop()
			self.SoundSwing = nil
		end
		if self.SoundHit then
			self.SoundHit:Stop()
			self.SoundHit = nil
		end
	else
		self:PlayWeaponSound(self:GetOnSound())
		self:SetHoldType(self:GetTargetHoldType())
		timer.Remove("ls_ht")
		if !SERVER then return end
		self.SoundLoop = CreateSound(self:GetOwner(), Sound(self.LoopSound))
		if self.SoundLoop then
			self.SoundLoop:Play()
		end
		self.SoundSwing = CreateSound(self:GetOwner(), Sound(self.SwingSound))
		if self.SoundSwing then
			self.SoundSwing:Play()
			self.SoundSwing:ChangeVolume(0, 0)
		end
		self.SoundHit = CreateSound(self:GetOwner(), Sound("lightsaber/saber_hit.wav"))
		if self.SoundHit then
			self.SoundHit:Play()
			self.SoundHit:ChangeVolume(0, 0)
		end
	end
	self:SetEnabled(!self:GetEnabled())
end

function SWEP:GetTargetHoldType()
	if (self:GetWorldModel() == "models/weapons/starwars/w_maul_saber_staff_hilt.mdl") then return "knife" end
	if (self:LookupAttachment("blade2") and self:LookupAttachment("blade2") > 0) then return "knife" end
	return "melee2"
end

function SWEP:OnDrop()
	if CLIENT then LS_SaberClean(self:EntIndex()) return end
	if self.SoundLoop then
		self.SoundLoop:Stop()
		self.SoundLoop = nil
	end
	if self.SoundSwing then
		self.SoundSwing:Stop()
		self.SoundSwing = nil
	end
	if self.SoundHit then
		self.SoundHit:Stop()
		self.SoundHit = nil
	end
end

function SWEP:OnRemove()
	if CLIENT then LS_SaberClean(self:EntIndex()) return end
	if self.SoundLoop then
		self.SoundLoop:Stop()
		self.SoundLoop = nil
	end
	if self.SoundSwing then
		self.SoundSwing:Stop()
		self.SoundSwing = nil
	end
	if self.SoundHit then
		self.SoundHit:Stop()
		self.SoundHit = nil
	end
end

LS_LightsaberModels = {
	["models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl"] = true,
	["models/sgg/starwars/weapons/w_anakin_ep3_saber_hilt.mdl"] = true,
	["models/sgg/starwars/weapons/w_common_jedi_saber_hilt.mdl"] = true,
	["models/sgg/starwars/weapons/w_luke_ep6_saber_hilt.mdl"] = true,
	["models/sgg/starwars/weapons/w_mace_windu_saber_hilt.mdl"] = true,
	["models/sgg/starwars/weapons/w_maul_saber_half_hilt.mdl"] = true,
	["models/sgg/starwars/weapons/w_obiwan_ep1_saber_hilt.mdl"] = true,
	["models/sgg/starwars/weapons/w_obiwan_ep3_saber_hilt.mdl"] = true,
	["models/sgg/starwars/weapons/w_quigon_gin_saber_hilt.mdl"] = true,
	["models/sgg/starwars/weapons/w_sidious_saber_hilt.mdl"] = true,
	["models/sgg/starwars/weapons/w_vader_saber_hilt.mdl"] = true,
	["models/sgg/starwars/weapons/w_yoda_saber_hilt.mdl"] = true,
	["models/weapons/starwars/w_maul_saber_staff_hilt.mdl"] = true,
	["models/weapons/starwars/w_dooku_saber_hilt.mdl"] = true
}

LS_LightsaberHumSounds = {
	["lightsaber/saber_loop1.wav"] = true,
	["lightsaber/saber_loop2.wav"] = true,
	["lightsaber/saber_loop3.wav"] = true,
	["lightsaber/saber_loop4.wav"] = true,
	["lightsaber/saber_loop5.wav"] = true,
	["lightsaber/saber_loop6.wav"] = true,
	["lightsaber/saber_loop7.wav"] = true,
	["lightsaber/saber_loop8.wav"] = true,
	["lightsaber/darksaber_loop.wav"] = true
}

LS_LightsaberSwingSounds = {
	["lightsaber/saber_swing1.wav"] = true,
	["lightsaber/saber_swing2.wav"] = true,
	["lightsaber/darksaber_swing.wav"] = true
}

LS_LightsaberOnSounds = {
	["lightsaber/saber_on1.wav"] = true,
	["lightsaber/saber_on1_fast.wav"] = true,
	["lightsaber/saber_on2.wav"] = true,
	["lightsaber/saber_on2_fast.wav"] = true,
	["lightsaber/saber_on3.wav"] = true,
	["lightsaber/saber_on3_fast.wav"] = true,
	["lightsaber/saber_on4.wav"] = true,
	["lightsaber/saber_on4_fast.wav"] = true,
	["lightsaber/darksaber_on.wav"] = true
}

LS_LightSaberOffSounds = {
	["lightsaber/saber_off1.wav"] = true,
	["lightsaber/saber_off1_fast.wav"] = true,
	["lightsaber/saber_off2.wav"] = true,
	["lightsaber/saber_off2_fast.wav"] = true,
	["lightsaber/saber_off3.wav"] = true,
	["lightsaber/saber_off3_fast.wav"] = true,
	["lightsaber/saber_off4.wav"] = true,
	["lightsaber/saber_off4_fast.wav"] = true,
	["lightsaber/darksaber_off.wav"] = true
}

function SWEP:Deploy()
	local ply = self:GetOwner()
	if !IsValid(ply) then return end
	timer.Create("LS_Apply_"..self:EntIndex(), 0, 1, function()
		if SERVER and IsValid(ply) and ply:IsPlayer() and IsValid(self) then
			self:SetMaxLength(math.Clamp(ply:GetInfoNum("lightsaber_bladel", 42), 32, 64))
			self:SetCrystalColor(Vector(ply:GetInfo("lightsaber_red"), ply:GetInfo("lightsaber_green"), ply:GetInfo("lightsaber_blue")))
			self:SetDarkInner(ply:GetInfo("lightsaber_dark") == "1")
			self:SetWorldModel(LS_LightsaberModels[ply:GetInfo("lightsaber_model")] and ply:GetInfo("lightsaber_model") or "models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl")
			self:SetBladeWidth(math.Clamp(ply:GetInfoNum("lightsaber_bladew", 2), 2, 4))
			self.LoopSound = LS_LightsaberHumSounds[ply:GetInfo("lightsaber_humsound")] and ply:GetInfo("lightsaber_humsound") or "lightsaber/saber_loop1.wav"
			self.SwingSound = LS_LightsaberSwingSounds[ply:GetInfo("lightsaber_swingsound")] and ply:GetInfo("lightsaber_swingsound") or "lightsaber/saber_swing1.wav"
			self:SetOnSound(LS_LightsaberOnSounds[ply:GetInfo("lightsaber_onsound")] and ply:GetInfo("lightsaber_onsound") or "lightsaber/saber_on1.wav")
			self:SetOffSound(LS_LightSaberOffSounds[ply:GetInfo("lightsaber_offsound")] and ply:GetInfo("lightsaber_offsound") or "lightsaber/saber_off1.wav")
		end
	end)
	if self:GetEnabled() then
		self:PlayWeaponSound(self:GetOnSound())
	end
	if CLIENT then return true end
	if ply:FlashlightIsOn() then
		ply:Flashlight(false)
	end
	self:SetBladeLength(0)
	if self:GetEnabled() then
		self.SoundLoop = CreateSound(ply, Sound(self.LoopSound))
		if self.SoundLoop then self.SoundLoop:Play() end
		self.SoundSwing = CreateSound(ply, Sound(self.SwingSound))
		if self.SoundSwing then self.SoundSwing:Play() self.SoundSwing:ChangeVolume(0, 0) end
		self.SoundHit = CreateSound(ply, Sound("lightsaber/saber_hit.wav"))
		if self.SoundHit then self.SoundHit:Play() self.SoundHit:ChangeVolume(0, 0) end
	end
	if !self:GetEnabled() then
		self:SetHoldType("normal")
	else
		self:SetHoldType(self:GetTargetHoldType())
	end
	return true
end

function SWEP:Holster()
	if self:GetEnabled() and IsValid(self:GetOwner()) then
		self:PlayWeaponSound(self:GetOffSound())
	end
	if CLIENT then
		LS_SaberClean(self:EntIndex())
		return true
	end
	if self.SoundLoop then
		self.SoundLoop:Stop()
		self.SoundLoop = nil
	end
	if self.SoundSwing then
		self.SoundSwing:Stop()
		self.SoundSwing = nil
	end
	if self.SoundHit then
		self.SoundHit:Stop()
		self.SoundHit = nil
	end
	return true
end

function SWEP:GetSaberPosAng(num)
	num = num or 1
	if IsValid(self:GetOwner())then
		local bone = self:GetOwner():LookupBone("ValveBiped.Bip01_R_Hand")
		local attachment = self:LookupAttachment("blade"..num)
		if (attachment and attachment > 0) then
			local PosAng = self:GetAttachment(attachment)
			if (!bone and SERVER) then
				PosAng.Pos = PosAng.Pos + Vector(0, 0, 36)
				if (SERVER and IsValid(self:GetOwner()) and self:GetOwner():Crouching()) then PosAng.Pos = PosAng.Pos - Vector(0, 0, 18) end
				PosAng.Ang.p = 0
			end
			return PosAng.Pos, PosAng.Ang:Forward()
		end
		if bone then
			local pos, ang
			local matrix = self:GetOwner():GetBoneMatrix(bone)
			if matrix then
				pos = matrix:GetTranslation()
				ang = matrix:GetAngles()
			else
				pos, ang = self:GetOwner():GetBonePosition(bone)
			end
			ang:RotateAroundAxis(ang:Forward(), 180)
			ang:RotateAroundAxis(ang:Up(), 30)
			ang:RotateAroundAxis(ang:Forward(), -5.7)
			ang:RotateAroundAxis(ang:Right(), 92)
			pos = pos + ang:Up() * -3.3 + ang:Right() * 0.8 + ang:Forward() * 5.6
			return pos, ang:Forward()
		end
	end
	local defAng = self:GetAngles()
	defAng.p = 0
	local defPos = self:GetPos() + defAng:Right() * 0.6 - defAng:Up() * 0.2 + defAng:Forward() * 0.8
	if SERVER then defPos = defPos + Vector(0, 0, 36) end
	if (SERVER and IsValid(self:GetOwner()) and self:GetOwner():Crouching()) then defPos = defPos - Vector(0, 0, 18) end
	return defPos, -defAng:Forward()
end

function SWEP:OnForceChanged(name, old, new)
	if (old > new) then
		self.NextForce = CurTime() + 4
	end
end

function SWEP:Think()
	self.WorldModel = self:GetWorldModel()
	self:SetModel(self:GetWorldModel())
	if (self.ForcePowers[self:GetForceType()]and self.ForcePowers[self:GetForceType()].think and !self:GetOwner():KeyDown(IN_USE)) then
		self.ForcePowers[self:GetForceType()].think(self)
	end
	if SERVER then
		if ((self.NextForce or 0) < CurTime()) then
			self:SetForce(math.min(self:GetForce() + 0.5, 100))
		end
		if (!self:GetEnabled() and self:GetBladeLength() != 0) then
			self:SetBladeLength(math.Approach(self:GetBladeLength(), 0, 2))
		elseif (self:GetEnabled() and self:GetBladeLength() != self:GetMaxLength()) then
			self:SetBladeLength(math.Approach(self:GetBladeLength(), self:GetMaxLength(), 8))
		end
	end
	if (self:GetBladeLength() <= 0) then return end
	local isTrace1Hit = false
	local pos, ang = self:GetSaberPosAng()
	local trace = util.TraceLine({start = pos,endpos = pos + ang * self:GetBladeLength(),filter = {self, self:GetOwner()},})
	local traceBack = util.TraceLine({start = pos + ang * self:GetBladeLength(),endpos = pos,filter = {self, self:GetOwner()},})
	if (trace.HitSky or trace.StartSolid) then trace.Hit = false end
	if (traceBack.HitSky or traceBack.StartSolid) then traceBack.Hit = false end
	self:DrawHitEffects(trace, traceBack)
	isTrace1Hit = trace.Hit or traceBack.Hit
	if (traceBack.Entity == trace.Entity and IsValid(trace.Entity)) then traceBack.Hit = false end
	if trace.Hit and SERVER then LS_DoDamage(trace, self) end
	if traceBack.Hit and SERVER then LS_DoDamage(traceBack, self) end
	local isTrace2Hit = false
	local lookup_Attachment = self:LookupAttachment("blade2")
	if (lookup_Attachment and lookup_Attachment > 0) then
		local pos2, dir2 = self:GetSaberPosAng(2)
		local trace2 = util.TraceLine({start = pos2,endpos = pos2 + dir2 * self:GetBladeLength(),filter = {self, self:GetOwner()},})
		local traceBack2 = util.TraceLine({start = pos2 + dir2 * self:GetBladeLength(),endpos = pos2,filter = {self, self:GetOwner()},})
		if (trace2.HitSky or trace2.StartSolid) then trace2.Hit = false end
		if (traceBack2.HitSky or traceBack2.StartSolid) then traceBack2.Hit = false end
		self:DrawHitEffects(trace2, traceBack2)
		isTrace2Hit = trace2.Hit or traceBack2.Hit
		if (traceBack2.Entity == trace2.Entity and IsValid(trace2.Entity)) then traceBack2.Hit = false end
		if trace2.Hit and SERVER then LS_DoDamage(trace2, self) end
		if traceBack2.Hit and SERVER then LS_DoDamage(traceBack2, self) end
	end
	if SERVER then
		if ((isTrace1Hit or isTrace2Hit) and self.SoundHit) then
			self.SoundHit:ChangeVolume(math.Rand(0.1, 0.5), 0)
		elseif self.SoundHit then
			self.SoundHit:ChangeVolume(0, 0)
		end
		if self.SoundSwing then
			if (self.LastAng != ang) then
				self.LastAng = self.LastAng or ang
				self.SoundSwing:ChangeVolume(math.Clamp(ang:Distance(self.LastAng) / 2, 0, 1), 0)
			end
			self.LastAng = ang
		end
		if self.SoundLoop then
			pos = pos + ang * self:GetBladeLength()
			if (self.LastPos != pos) then
				self.LastPos = self.LastPos or pos
				self.SoundLoop:ChangeVolume(0.1 + math.Clamp(pos:Distance(self.LastPos) / 128, 0, 0.2), 0)
			end
			self.LastPos = pos
		end
	end
end

function SWEP:DrawHitEffects(trace, traceBack)
	if (self:GetBladeLength() <= 0) then return end
	if trace.Hit then
		LS_DrawHit(trace.HitPos, trace.HitNormal)
	end
	if traceBack and traceBack.Hit then
		LS_DrawHit(traceBack.HitPos, traceBack.HitNormal)
	end
end

local index = ACT_HL2MP_IDLE_KNIFE
local KnifeHoldType = {}
KnifeHoldType[ACT_MP_STAND_IDLE] = index
KnifeHoldType[ACT_MP_WALK] = index + 1
KnifeHoldType[ACT_MP_RUN] = index + 2
KnifeHoldType[ACT_MP_CROUCH_IDLE] = index + 3
KnifeHoldType[ACT_MP_CROUCHWALK] = index + 4
KnifeHoldType[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = index + 5
KnifeHoldType[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] = index + 5
KnifeHoldType[ACT_MP_RELOAD_STAND] = index + 6
KnifeHoldType[ACT_MP_RELOAD_CROUCH] = index + 6
KnifeHoldType[ACT_MP_JUMP] = index + 7
KnifeHoldType[ACT_RANGE_ATTACK1] = index + 8
KnifeHoldType[ACT_MP_SWIM] = index + 9

function SWEP:TranslateActivity(act)
	if !IsValid(self:GetOwner()) then return end
	if self:GetOwner():Crouching() then
		local tr = util.TraceHull({start = self:GetOwner():GetShootPos(), endpos = self:GetOwner():GetShootPos() + Vector(0, 0, 20), mins = self:GetOwner():OBBMins(), maxs = self:GetOwner():OBBMaxs(), filter = self:GetOwner()})
		if (self:GetEnabled() and tr.Hit and act == ACT_MP_ATTACK_CROUCH_PRIMARYFIRE) then return ACT_HL2MP_IDLE_KNIFE + 5 end
		if ((!self:GetEnabled() and self:GetHoldType() == "normal") and self:GetOwner():Crouching() and act == ACT_MP_CROUCH_IDLE) then return ACT_HL2MP_IDLE_KNIFE + 3 end
		if (((!self:GetEnabled() and self:GetHoldType() == "normal") or (self:GetEnabled() and tr.Hit)) and act == ACT_MP_CROUCH_IDLE) then return ACT_HL2MP_IDLE_KNIFE + 3 end
		if (((!self:GetEnabled() and self:GetHoldType() == "normal") or (self:GetEnabled() and tr.Hit)) and act == ACT_MP_CROUCHWALK) then return ACT_HL2MP_IDLE_KNIFE + 4 end
	end
	if (self:GetOwner():WaterLevel() > 1 and self:GetEnabled()) then
		return KnifeHoldType[act]
	end
	if (self.ActivityTranslate[act] != nil) then return self.ActivityTranslate[act]end
	return -1
end

if SERVER then return end

killicon.Add("weapon_lightsaber", "lightsaber/lightsaber_killicon", color_white)

function SWEP:DrawWorldModel()
	self.WorldModel = self:GetWorldModel()
	self:SetModel(self:GetWorldModel())
	self:DrawModel()
end

function SWEP:DrawWorldModelTranslucent()
	if !IsValid(self:GetOwner()) then return end
	local clr = self:GetCrystalColor()
	clr = Color(clr.x, clr.y, clr.z)
	local pos, dir = self:GetSaberPosAng()
	LS_RenderBlade(self, pos, dir, self:GetBladeLength(), self:GetMaxLength(), self:GetBladeWidth(), clr, self:GetDarkInner(), self:EntIndex(), self:GetOwner():WaterLevel() > 2)
	if (self:LookupAttachment("blade2") > 0) then
		local pos, dir = self:GetSaberPosAng(2)
		LS_RenderBlade(self, pos, dir, self:GetBladeLength(), self:GetMaxLength(), self:GetBladeWidth(), clr, self:GetDarkInner(), self:EntIndex() + 655, self:GetOwner():WaterLevel() > 2)
	end
end

local function lightsaber_3rdperson(ply, pos, ang)
	if (!ply:Alive() or ply:InVehicle() or ply:GetViewEntity() != ply) then return end
	local local_ply = LocalPlayer()
	if (!local_ply:GetActiveWeapon():IsValid() or local_ply:GetActiveWeapon():GetClass() != "weapon_lightsaber") then return end
	local trace = util.TraceHull({start = pos,endpos = pos - ang:Forward() * 100,filter = {ply:GetActiveWeapon(), ply},mins = Vector(-4, -4, -4),maxs = Vector(4, 4, 4),})
	if (trace.Hit) then pos = trace.HitPos else pos = pos - ang:Forward() * 100 end
	return {origin = pos, angles = ang, drawviewer = true}
end
hook.Add("CalcView", "lightsaber_3rdperson", lightsaber_3rdperson)

surface.CreateFont("SelectedForceType", {font = "Roboto Cn", size = ScreenScale(16), weight = 600})
surface.CreateFont("SelectedForceHUD", {font = "Roboto Cn", size = ScreenScale(6)})

local ForceSelectEnabled = false
hook.Add("PlayerBindPress", "sabers_force", function(ply, bind, pressed)
	local local_ply = LocalPlayer()
	if (local_ply:InVehicle() or ply != local_ply or !local_ply:Alive() or !local_ply:GetActiveWeapon():IsValid() or local_ply:GetActiveWeapon():GetClass() != "weapon_lightsaber") then ForceSelectEnabled = false return end
	if (bind == "impulse 100" and pressed) then
		ForceSelectEnabled = !ForceSelectEnabled
		return true
	end
	if !ForceSelectEnabled then return end
	if bind:StartWith("slot") then
		RunConsoleCommand("select_force", bind:sub(5))
		return true
	end
end)

local lightsaber_hud_blur = CreateClientConVar("lightsaber_hud_blur", 1)
local grad = Material("gui/gradient_up")
local matBlurScreen = Material("pp/blurscreen")
matBlurScreen:SetFloat("$blur", 3)
matBlurScreen:Recompute()
local function DrawHUDBox(x, y, w, h, b)
	x = math.floor(x)
	y = math.floor(y)
	w = math.floor(w)
	h = math.floor(h)
	surface.SetMaterial(matBlurScreen)
	surface.SetDrawColor(255, 255, 255, 255)
	if lightsaber_hud_blur:GetBool() then
		render.SetScissorRect(x, y, w + x, h + y, true)
		for i = 0.33, 1, 0.33 do
			matBlurScreen:SetFloat("$blur", 5 * i)
			matBlurScreen:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
		end
		render.SetScissorRect(0, 0, 0, 0, false)
	else
		draw.NoTexture()
		surface.SetDrawColor(Color(0, 0, 0, 128))
		surface.DrawTexturedRect(x, y, w, h)
	end
	surface.SetDrawColor(Color(0, 0, 0, 128))
	surface.DrawRect(x, y, w, h)
	if b then
		surface.SetMaterial(grad)
		surface.SetDrawColor(Color(0, 128, 255, 4))
		surface.DrawTexturedRect(x, y, w, h)
	end
end

local ForceBar = 100
function SWEP:DrawHUD()
	if (!IsValid(self:GetOwner()) or self:GetOwner():GetViewEntity() != self:GetOwner() or self:GetOwner():InVehicle()) then return end
	local icon = 52
	local gap = 5
	local bar = 4
	local bar2 = 16
	if ForceSelectEnabled then
		icon = 128
		bar = 8
		bar2 = 24
	end
	ForceBar = math.min(100, Lerp(0.1, ForceBar, math.floor(self:GetForce())))
	local w = #self.ForcePowers * icon + (#self.ForcePowers - 1) * gap
	local h = bar2
	local x = math.floor(ScrW() / 2 - w / 2)
	local y = ScrH() - gap - bar2
	DrawHUDBox(x, y, w, h)
	local barW = math.ceil(w * (ForceBar / 100))
	if (self:GetForce() <= 1 and barW <= 1) then barW = 0 end
	draw.RoundedBox(0, x, y, barW, h, Color(0, 128, 255, 255))
	draw.SimpleText(math.floor(self:GetForce()).."%", "SelectedForceHUD", x + w / 2, y + h / 2, Color(255, 255, 255), 1, 1)
	local y = y - icon - gap
	local h = icon
	for id, t in pairs(self.ForcePowers) do
		local x = x + (id - 1) * (h + gap)
		local x2 = math.floor(x + icon / 2)
		DrawHUDBox(x, y, h, h, self:GetForceType() == id)
		draw.SimpleText(self.ForcePowers[id].icon or "", "SelectedForceType", x2, math.floor(y + icon / 2), Color(255, 255, 255), 1, 1)
		if ForceSelectEnabled then
			draw.SimpleText((input.LookupBinding("slot"..id) or "<NICHT GEBUNDEN>"):upper(), "SelectedForceHUD", x + gap, y + gap, Color(255, 255, 255))
		end
		if (self:GetForceType() == id) then
			local y = y + (icon - bar)
			surface.SetDrawColor(0, 128, 255, 255)
			draw.NoTexture()
			surface.DrawPoly({{x = x2 - bar, y = y},{x = x2, y = y - bar}, {x = x2 + bar, y = y}})
			draw.RoundedBox(0, x, y, h, bar, Color(0, 128, 255, 255))
		end
	end
	if ForceSelectEnabled then
		surface.SetFont("SelectedForceHUD")
		local tW, tH = surface.GetTextSize(self.ForcePowers[self:GetForceType()].description or "")
		local x = ScrW() / 2 + gap
		local y = y - tH - gap * 3
		DrawHUDBox(x, y, tW + gap * 2, tH + gap * 2)
		for id, txt in pairs(string.Explode("\n", self.ForcePowers[self:GetForceType()].description or "")) do
			draw.SimpleText(txt, "SelectedForceHUD", x + gap, y + (id - 1) * ScreenScale(6) + gap, Color(255, 255, 255))
		end
	end
	if !ForceSelectEnabled then
		surface.SetFont("SelectedForceHUD")
		local txt = "Drücke "..(input.LookupBinding("impulse 100") or "<NICHT GEBUNDEN>"):upper().." um die Kraftauswahl aufzurufen"
		local tW, tH = surface.GetTextSize(txt)
		local x = x + w / 2
		local y = y - tH - gap
		DrawHUDBox(x - tW / 2 - 5, y, tW + 10, tH)
		draw.SimpleText(txt, "SelectedForceHUD", x, y, Color(255, 255, 255), 1)
		local isGood = hook.Call("PlayerBindPress", nil, LocalPlayer(), "this_bind_doesnt_exist", true)
		if (isGood == true) then
			local tW, tH = surface.GetTextSize(txt)
			y = y - tH - gap
			local id = 1
			DrawHUDBox(x - tW / 2 - 5, y, tW + 10, tH)
			draw.SimpleText(string.Explode("\n", txt)[1], "SelectedForceHUD", x, y + 0, Color(255, 230, 230), 1)
			for str, func in pairs(hook.GetTable()["PlayerBindPress"]) do
				local clr = Color(255, 255, 128)
				if ((isstring(str) and func(LocalPlayer(), "this_bind_doesnt_exist", true) == true) or (!isstring(str) and func(str, LocalPlayer(), "this_bind_doesnt_exist", true) == true)) then
					clr = Color(255, 128, 128)
				end
				if (!isstring(str)) then str = tostring(str) end
				if (str == "") then str = "<empty string hook>" end
				local _, lineH = surface.GetTextSize(str)
				draw.SimpleText(str, "SelectedForceHUD", x, y + id * lineH, clr, 1)
				id = id + 1
			end
		end
	end
	if ForceSelectEnabled then
		surface.SetFont("SelectedForceType")
		local txt = self.ForcePowers[self:GetForceType()].name or ""
		local tW2, tH2 = surface.GetTextSize(txt)
		local x = x + w / 2 - tW2 - gap * 2//+ w / 2
		local y = y + gap - tH2 - gap * 2
		DrawHUDBox(x, y, tW2 + 10, tH2)
		draw.SimpleText(txt, "SelectedForceType", x + gap, y, Color(255, 255, 255))
	end
	local isTarget = self.ForcePowers[self:GetForceType()].target
	if isTarget then
		for id, ent in pairs(self:SelectTargets(isTarget)) do
			if !IsValid(ent) then continue end
			local maxs = ent:OBBMaxs()
			local p = ent:GetPos()
			p.z = p.z + maxs.z
			local pos = p:ToScreen()
			local x, y = pos.x, pos.y
			local size = 16
			surface.SetDrawColor(255, 0, 0, 255)
			draw.NoTexture()
			surface.DrawPoly({{x = x - size, y = y - size},{x = x + size, y = y - size},{x = x, y = y}})
		end
	end
end