if SERVER then
	AddCSLuaFile()
end

if CLIENT then
	language.Add("blinks_ammo", "Teleportationen")
end

game.AddAmmoType({name = "blinks", dmgtype = DMG_SONIC})

SWEP.Base = "weapon_base"
SWEP.Category = "Legendäre Waffen"
SWEP.Spawnable = true
SWEP.HoldType = "magic"
SWEP.PrintName = "Teleportationsfähigkeit"
SWEP.Purpose = "Hiermit kannst du dich bis zu 2 Mal teleportieren. Viel Spaß!"
SWEP.Author = "Modern Gaming"
SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 67
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_slam.mdl"
SWEP.WorldModel = Model("models/weapons/w_slam.mdl")
SWEP.Primary.ClipSize = 2
SWEP.Primary.DefaultClip = 2
SWEP.Primary.Delay = 1
SWEP.Primary.Ammo = "blinks"
SWEP.Secondary.Ammo = "none"
SWEP.IsGun = true

if CLIENT then
	local blink_effect = {
		["$pp_colour_addr"] = 0,
		["$pp_colour_addg"] = 0,
		["$pp_colour_addb"] = 0,
		["$pp_colour_brightness"] = -0.1,
		["$pp_colour_contrast"] = 1.25,
		["$pp_colour_colour"] = 0,
		["$pp_colour_mulr"] = 0,
		["$pp_colour_mulg"] = 0,
		["$pp_colour_mulb"] = 0
	}
	local local_ply
	local fade = 0.1

	local function RenderEffects()
		local_ply = local_ply or LocalPlayer()
		local wep = local_ply:GetActiveWeapon()
		if wep:IsValid() and wep:GetNW2Float("Blinking") > 0 then
			local iter = math.min(1, 1 - ((wep:GetNW2Float("Blinking") + fade) - CurTime()) / fade)
			blink_effect["$pp_colour_addb"] = iter * 0.05
			blink_effect["$pp_colour_brightness"] = iter * -0.15
			blink_effect["$pp_colour_mulb"] = iter
			blink_effect["$pp_colour_contrast"] = 1 + iter * 0.05
			blink_effect["$pp_colour_colour"] = math.max(0.2, 1 * (1 - iter))
			DrawColorModify(blink_effect)
			DrawBloom(1 - iter * 0.2, iter * 8, iter * 4, iter * 8, 2, iter * 0.5, iter * 0.8, iter * 0.8, iter * 0.9)
		end
	end
	hook.Add("RenderScreenspaceEffects", "Blink_BlinkEffects", RenderEffects)
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
	if !IsValid(self.Owner) then return end
	local vm = self.Owner:GetViewModel()
	if IsValid(vm) then
		vm:SendViewModelMatchingSequence(12)
	end
	return true
end

function SWEP:Holster()
	if IsValid(self.LastPlayer) then
		self:StopBlinking(self.LastPlayer)
	end
	return true
end

function SWEP:OnDrop()
	if IsValid(self.LastPlayer) then
		self:StopBlinking(self.LastPlayer)
	end
	return true
end

function SWEP:DoTrace()
    local ply = self.Owner
    local phys = ply:GetPhysicsObject()
    local size = Vector(34, 34, 74)
    local tr0 = util.TraceHull({
        start = ply:EyePos(),
        endpos = ply:EyePos() + ply:EyeAngles():Forward() * 1768,
        mins = size / -4,
        maxs = size / 4,
        mask = MASK_SOLID,
        filter = ply
    })
    local final = tr0.HitPos - Vector(0, 0, size.z / 2)
    local ledge = final + Vector(0, 0, size.z)
    local tr1 = util.TraceLine({
        start = ledge,
        endpos = ledge + ply:EyeAngles():Forward() * size.y * 2,
        mask = MASK_SOLID,
        filter = ply
    })
    if !tr1.Hit then
        local tr2 = util.TraceLine({
            start = tr1.HitPos,
            endpos = tr1.HitPos - Vector(0, 0, size.z),
            mask = MASK_SOLID,
            filter = ply
        })
        if tr2.Hit then
			final = tr2.HitPos + Vector(0, 0, 8)
		end
    end
    return final
end

local aim  = {Sound("vadim_blink/aim1.mp3"), Sound("vadim_blink/aim2.mp3")}
local tpl  = {Sound("vadim_blink/teleport1.mp3"), Sound("vadim_blink/teleport2.mp3")}
function SWEP:StartBlinking(ply)
	if self:GetNW2Float("Blinking") > 0 then return end
	ply:SetMoveType(MOVETYPE_WALK)
	local pos = self:DoTrace()
	if SERVER then
		self.BlinkInfo = {pos, CurTime() + 2}
		ply.BlinkImmune = true
		ply:SetFOV(120, 0.5)
	end
	ply:EmitSound(aim[math.random(1,2)], 125)
	self:SetNW2Float("Blinking", CurTime())
	self.LastPlayer = ply
	self:TakePrimaryAmmo(1)
end

function SWEP:StopBlinking(ply)
	if self:GetNW2Float("Blinking") <= 0 then return end
	if SERVER then
		ply:SetFOV(0, 0.25)
	end
	ply:EmitSound(tpl[math.random(1,2)], 125)
	self:SetNW2Float("Blinking", 0)
	if SERVER then
		ply:SetVelocity(-ply:GetVelocity() * 0.95)
		self.BlinkInfo = false
		self.RetryBlink = nil
		timer.Simple(0.25, function()
			if IsValid(ply) then
				ply.BlinkImmune = nil
			end
		end)
		if self:Clip1() <= 0 then
			timer.Simple(0.1, function()
				if !IsValid(ply) or !IsValid(self) then return end
				ply:ConCommand("lastinv")
				self:Remove()
			end)
		end
	end
end

function SWEP:PrimaryAttack()
	if !IsValid(self.Owner) then return end
	self:StartBlinking(self.Owner)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + 0.15)
end

function SWEP:SecondaryAttack()
	if !IsValid(self.Owner) then return end
	self:StopBlinking(self.Owner)
end

function SWEP:Think()
	if CLIENT then
		if self:GetNW2Float("Blinking") > 0 then
			self.BobScale = 0
			self.SwayScale = 0
		else
			self.BobScale = 1
			self.SwayScale = 1
		end
	end
	local ply = self.Owner
    if SERVER and IsValid(ply) and self.BlinkInfo then
        if CurTime() >= self.BlinkInfo[2] then
			self:StopBlinking(ply)
			return
		end
		if ply.LastBlinkPos and ply.LastBlinkPos:DistToSqr(ply:GetPos()) <= 150 then
			if !self.RetryBlink then
				self.RetryBlink = CurTime() + 0.15
			end
			if self.RetryBlink < CurTime() then
				self:StopBlinking(ply)
				return
			end
		end
        if ply:GetPos():DistToSqr(self.BlinkInfo[1]) <= 1500 then
            self:StopBlinking(ply)
            ply:ViewPunch(Angle(2, 0, 0))
            return 
        end
        ply:SetVelocity((self.BlinkInfo[1] - ply:GetPos()):GetNormalized() * 3182 - ply:GetVelocity())
		ply.LastBlinkPos = ply:GetPos()
    end
end

function SWEP:PreDrawViewModel()
	render.SetBlend(0)
end

function SWEP:ViewModelDrawn()
	render.SetBlend(1)
end

function SWEP:DrawWorldModel()
	if !IsValid(self.Owner) then
		self:DrawModel()
		self:SetColor(Color(255, 0, 0))
	end
end

hook.Add("EntityTakeDamage", "TTT_BlinkInvincibilty", function(ply, dmg)
	if ply.BlinkImmune then
		return true
	end
end)

hook.Add("PlayerFootstep", "Blink_MuteFootsteps", function(ply)
	local wep = ply:GetActiveWeapon()
	if wep:IsValid() and wep:GetNW2Float("Blinking") > 0 then
		return true
	end
end)

if SERVER then
	hook.Add("Flopper_CanExplode", "Blink_FlopperFix", function(ply)
		local wep = ply:GetActiveWeapon()
		if wep:IsValid() and wep:GetNW2Float("Blinking") > 0 then
			return false
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

	hook.Add("PVP_HighlightPlayerNames", "Blink_HideName", function(ply)
		local wep = ply:GetActiveWeapon()
		if wep:IsValid() and wep:GetNW2Float("Blinking") > 0 then
			return false
		end
	end)
end