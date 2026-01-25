if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	language.Add("motherfucking magic_ammo", "Magie")
end

game.AddAmmoType({name = "motherfucking magic", dmgtype = DMG_GENERIC})

SWEP.HoldType = "slam"
SWEP.PrintName = "Uhr der Unsichtbarkeit"
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.DrawCrosshair = false
SWEP.Spawnable = true
SWEP.Category = "Legendäre Waffen"
SWEP.Instructions = "Macht dich für kurze Zeit unsichtbar."

SWEP.Base = "weapon_basekit"
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_slam.mdl"
SWEP.WorldModel = Model("models/props_combine/breenclock.mdl")

SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 100
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "motherfucking magic"
SWEP.Primary.Delay = 1
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.IsGun = true

SWEP.ViewModelBoneMods = {
	["Detonator"] = {scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}
SWEP.VElements = {
	["v_cloak"] = {type = "Model", model = "models/props_combine/breenclock.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4.8, 2.56, 1), angle = Angle(-40, 80, 20), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 2, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["w_cloak"] = {type = "Model", model = "models/props_combine/breenclock.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 4, -1), angle = Angle(170, 40, -10), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

DEFINE_BASECLASS("weapon_basekit")

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	BaseClass.Initialize(self)
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_SLAM_DETONATOR_DRAW)
	if (self:GetNextPrimaryFire() < CurTime() + 1.2) then
		self:SetNextPrimaryFire(CurTime() + 1.2)
	end
	if IsValid(self.Owner) then
		Cloaking_SetInvis(self.Owner, false, false, false, false, false, false)
	end
	return true
end

function SWEP:Equip()
	if IsValid(self.Owner) then
		Cloaking_SetInvis(self.Owner, false, false, false, false, false, false)
	end
end

function SWEP:Holster()
	self:RemoveCloaking()
	BaseClass.Holster(self)
	return true
end

function SWEP:OnRemove()
	self:RemoveCloaking()
end

function SWEP:PreDrop()
	self:RemoveCloaking()
end

local function CreateInvisibleEffect(ply, big)
	local scale = 0.1
	if big then scale = 1 end
	if IsFirstTimePredicted() then
		local edata = EffectData()
		edata:SetOrigin(ply:GetShootPos())
		edata:SetScale(scale)
		util.Effect("cloak_disguise", edata, true, true)
	end
end

local heart = Sound("player/heartbeat1.wav")
local function DoMagic(ply, bool, sound, effect, nextattack, extra)
	if !IsValid(ply) or !ply:Alive() then return end
	local timer1 = "CloakingFunction_"..ply:EntIndex()
	if SERVER and effect then
		CreateInvisibleEffect(ply, true)
	end
	if bool then
		ply:SetNW2Bool("Cloaked", true)
		if SERVER then
			if PS_HideItems then
				PS_HideItems(ply, true)
			end
			ply:SetNoDraw(true)
			local wep = ply:GetActiveWeapon()
			if wep:IsValid() then
				wep:SetNoDraw(true)
			end
			if sound then
				local filter = RecipientFilter()
				filter:AddAllPlayers()
				filter:RemovePlayer(ply)
				ply.HeartBeat = CreateSound(ply, heart, filter)
				ply.HeartBeat:Play()
				ply.HeartBeat:ChangeVolume(0, 0)
				ply.HeartBeat:ChangeVolume(1, 1)
				ply:EmitSound("HL1/fvox/hiss.wav", 300)
				ply:ChatPrint("Du bist nun unsichtbar.")
			end
		end
		timer.Create(timer1, 0.2, 0, function()
			if !IsValid(ply) then timer.Remove(timer1) return end
			local wep = ply:GetWeapon("weapon_cloak")
			if !wep:IsValid() or ply:GetActiveWeapon() != wep or wep:Clip1() <= 0 then return end
			if SERVER then
				CreateInvisibleEffect(ply, false)
			end
			wep:SetClip1(wep:Clip1() - 1)
			if wep:Clip1() <= 0 and IsFirstTimePredicted() then
				timer.Remove(timer1)
				Cloaking_SetInvis(ply, false, true, true, false, true, true, true)
			end
		end)
	else
		if ply:GetNW2Bool("Cloaked") then
			if SERVER and PS_HideItems then
				PS_HideItems(ply, false)
			end
			local wep = ply:GetWeapon("weapon_cloak")
			if nextattack and IsValid(wep) and wep.Primary and wep.Primary.Delay then
				if (wep:GetNextPrimaryFire() < CurTime() + wep.Primary.Delay * (extra and 3 or 2)) then
					wep:SetNextPrimaryFire(CurTime() + wep.Primary.Delay * (extra and 3 or 2))
				end
			end
		end
		ply:SetNW2Bool("Cloaked", false)
		if SERVER then
			ply:SetNoDraw(false)
			local wep = ply:GetActiveWeapon()
			if wep:IsValid() then
				wep:SetNoDraw(false)
			end
			if ply.HeartBeat then
				ply.HeartBeat:Stop()
				ply.HeartBeat = nil
			end
			if sound then
				ply:EmitSound("HL1/fvox/hiss.wav", 300)
				ply:ChatPrint("Du bist nun sichtbar.")
			end
		end
		timer.Remove(timer1)
		timer.Create(timer1, 0.45, 0, function()
			if !IsValid(ply) then timer.Remove(timer1) return end
			local wep = ply:GetWeapon("weapon_cloak")
			if !IsValid(wep) or ply:GetActiveWeapon() != wep or !wep.Primary or !wep.Primary.ClipSize or wep:Clip1() >= wep.Primary.ClipSize then timer.Remove(timer1) return end
			wep:SetClip1(wep:Clip1() + 1)
			if wep:Clip1() >= wep.Primary.ClipSize then
				timer.Remove(timer1)
			end
		end)
	end
end

function Cloaking_SetInvis(ply, bool, sound, effect, allowtimer, nextattack, extra, drawviewmodelnotimer)
	if !IsValid(ply) then return end
	if allowtimer then
		timer.Simple(0.1, function()
			if (IsFirstTimePredicted() and IsValid(ply) and ply:GetActiveWeapon():IsValid() and ply:GetActiveWeapon():GetClass() == "weapon_cloak") then
				ply:DrawViewModel(ply:GetNW2Bool("Cloaked"))
				DoMagic(ply, bool, sound, effect, nextattack, extra)
			end
		end)
	else
		ply:GetNW2Bool("Cloaked")
		if drawviewmodelnotimer then
			ply:DrawViewModel(ply:GetNW2Bool("Cloaked"))
		end
		DoMagic(ply, bool, sound, effect, nextattack, extra)
	end
end

function SWEP:CanPrimaryAttack()
	if self:Clip1() <= 0 then
		return false
	end
	return true
end

local lever = Sound("buttons/lever7.wav")
function SWEP:PrimaryAttack()
	if !IsValid(self.Owner) or !self:CanPrimaryAttack() or self:GetNextPrimaryFire() > CurTime() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SendWeaponAnim(ACT_SLAM_DETONATOR_DETONATE)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:EmitSound(lever)
	if !IsFirstTimePredicted() then return end
	Cloaking_SetInvis(self.Owner, !self.Owner:GetNW2Bool("Cloaked"), true, true, true, true)
end

function SWEP:SecondaryAttack()
end

function SWEP:RemoveCloaking()
	if IsValid(self.Owner) and self.Owner:GetNW2Bool("Cloaked") then
		Cloaking_SetInvis(self.Owner, false, true, true, false, true, true)
	end
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
end

function SWEP:Reload()
end

if SERVER then
	hook.Add("PlayerHurt", "Cloaking_RemoveCloak", function(victim, attacker)
		local wep = victim:GetActiveWeapon()
		if wep:IsValid() and wep:GetClass() == "weapon_cloak" then
			if victim:GetNW2Bool("Cloaked") then
				Cloaking_SetInvis(victim, false, true, true, false, true, true, true)
			end
		end
	end)
end

if CLIENT then
	function SWEP:CustomAmmoDisplay()
		self.AmmoDisplay = self.AmmoDisplay or {}
		self.AmmoDisplay.Draw = true
		self.AmmoDisplay.PrimaryClip = self:Clip1()
		return self.AmmoDisplay
	end

	local ply, ent
	local function HidePlayerName()
		ply = ply or LocalPlayer()
		ent = ply:GetEyeTrace().Entity
		if IsValid(ent) and ent:GetNW2Bool("Cloaked") then
			return false
		end
	end
	hook.Add("HUDDrawTargetID", "Cloaking_HidePlayerName", HidePlayerName)
end