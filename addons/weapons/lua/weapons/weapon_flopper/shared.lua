if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.Base = "weapon_basekit"
SWEP.HoldType = "slam"
SWEP.PrintName = "Flopper Perk"
SWEP.Spawnable = true
SWEP.Category = "Legendäre Waffen"
SWEP.DrawCrosshair = false
SWEP.Purpose = "Erleide nie wieder Fallschaden. Einfach nur austrinken!"
SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/hoff/animations/perks/phdflopper/phd.mdl"
SWEP.WorldModel	= Model("models/props_junk/glassbottle01a.mdl")

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo	= "none"
SWEP.IsGun = true

SWEP.WElements = {
	["perk_bottle"] = {type = "Model", model = "models/props_junk/glassbottle01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 2, 0), angle = Angle(220, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

DEFINE_BASECLASS("weapon_basekit")

function SWEP:Initialize()
	self.Perk_IsDrinking = true
	self:SetHoldType(self.HoldType)
	BaseClass.Initialize(self)
end

function SWEP:Deploy()
	timer.Simple(0.45, function()
		if IsValid(self) and IsValid(self.Owner) and IsFirstTimePredicted() then
			self:EmitSound("hoff/animations/perks/017f11fa.wav")
			timer.Simple(0.5, function()
				if IsValid(self) and IsValid(self.Owner) and IsFirstTimePredicted() then
					self:EmitSound("hoff/animations/perks/0180acfa.wav")
					timer.Simple(1.35, function()
						if IsValid(self) and IsValid(self.Owner) and IsFirstTimePredicted() then
							self:EmitSound("hoff/animations/perks/017c99be.wav")
							timer.Simple(0.6, function()
								if IsValid(self) and IsValid(self.Owner) and IsFirstTimePredicted() then
									self:EmitSound("hoff/animations/perks/017bf9c0.wav")
									self.Perk_IsDrinking = false
									self.Owner.Flopper_Active = true
									if SERVER then
										self:Remove()
									end
								end
							end)
						end
					end)
				end
			end)
		end
	end)
	return true
end

function SWEP:Holster()
	if self.Perk_IsDrinking then
		return false
	else
		self:OnRemove()
	end
end

function SWEP:OnRemove()
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
		if self.Owner == LocalPlayer() then
			RunConsoleCommand("lastinv")
		end
	end
end

function SWEP:PrimaryAttack()
end

if SERVER then
	hook.Add("EntityTakeDamage", "Flopper_RemoveFallDamage", function(target, dmginfo)
		if target:IsPlayer() and target.IsFighter and target:IsFighter() and target.Flopper_Active then
			if dmginfo:IsFallDamage() then
				if hook.Run("Flopper_CanExplode", target, dmginfo) == false then return end
				local explode = ents.Create("env_explosion")
				explode:SetPos(target:GetPos())
				explode:SetOwner(target)
				explode:SetKeyValue("iMagnitude", "150")
				explode:Spawn()
				explode.Flopper = target
				explode:Fire("Explode", 0, 0)
				explode:EmitSound("weapon_AWP.Single", 500, 500)
				dmginfo:SetDamage(0)
			end
			if dmginfo:IsExplosionDamage() and dmginfo:GetInflictor().Flopper == target then
				dmginfo:SetDamage(0)
			end
		end
	end, HOOK_MONITOR_HIGH or -2)

	hook.Add("PlayerSpawn", "Flopper_Remove", function(ply)
		ply.Flopper_Active = nil
	end)

	hook.Add("PlayerDeath", "Flopper_Remove", function(ply)
		ply.Flopper_Active = nil
	end)
end

function SWEP:GetViewModelPosition(pos, ang)
 	local Right = ang:Right()
	local Up = ang:Up()
	local Forward = ang:Forward()
 	local Mul = 1
	local Offset = Vector(0, 0, -1)
	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul
	return pos, ang
end