SWEP.Category = "M9K Specialties"
SWEP.PrintName = "M202"
SWEP.DrawCrosshair = false
SWEP.Slot = 4
SWEP.SlotPos = 5
SWEP.Weight = 70
SWEP.HoldType = "rpg"
SWEP.ViewModelFOV = 73
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_m202.mdl"
SWEP.WorldModel = Model("models/weapons/w_m202.mdl")
SWEP.ShowWorldModel = false
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("M202F.single")
SWEP.Primary.RPM = 350
SWEP.Primary.ClipSize = 4
SWEP.Primary.DefaultClip = 4
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "m202_round"
SWEP.Primary.Round = "m9k_m202_rocket"
SWEP.ReloadAnim = ACT_VM_DRAW
SWEP.CanAim = false
SWEP.RunSightsPos = Vector(7.3256, 6.8881, -4.8875)
SWEP.RunSightsAng = Vector(-15.596, 53.0059, -11.98)
SWEP.WeaponType = "rpg"

SWEP.WElements = {
	["m202"] = {type = "Model", model = "models/weapons/w_m202.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(13.255, 1.021, -2.869), angle = Angle(180, 90, -11.981), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

function SWEP:AddDeploy()
	if SERVER then
		self:CheckWeaponsAndAmmo(0)
	end
end

function SWEP:PrimaryAttack()
	if self:GetLowered() then return end
	if self:CanPrimaryAttack() and !self:GetRunning() and !self:GetPredictedRunning() and !self:GetReloading() then
		if !self.FiresUnderWater then
			if IsValid(self.Owner) and self.Owner:WaterLevel() > 2 then
				return
			end
		end
		self:EmitSound(self.Primary.Sound)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self.Owner:MuzzleFlash()
		self:TakePrimaryAmmo(1)
		self:SetNextPrimaryFire(CurTime() + 1 / (self.Primary.RPM / 60))
		self.Owner:ViewPunch(Angle(-1, util.SharedRandom(self:GetClass(), -0.2, 0.2, 0), 0))
		if SERVER then
			self:FireGrenade()
			self:CheckWeaponsAndAmmo(self:SequenceDuration() * 0.25)
		end
	end
end

function SWEP:FireGrenade()
	local aim = self.Owner:EyeAngles():Forward()
	local side = aim:Cross(Vector(0, 0, 1))
	local up = side:Cross(aim)
	local pos = self.Owner:GetShootPos() + side * 5 + up *1.5
	local grenade = ents.Create(self.Primary.Round)
	if !IsValid(grenade) then return end
	grenade:SetAngles(aim:Angle())
	grenade:SetPos(pos)
	grenade:SetOwner(self.Owner)
	grenade:Spawn()
	grenade:Activate()
end

function SWEP:CheckWeaponsAndAmmo(Wait)
	if (self:Clip1() <= 0 and self.Owner:GetAmmoCount(self:GetPrimaryAmmoType()) <= 0) then
		timer.Simple(Wait, function()
			if !IsValid(self) then return end
			MG_RemoveWeapon(self)
		end)
	end
end

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end