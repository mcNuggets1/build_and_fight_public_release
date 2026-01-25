DEFINE_BASECLASS("weapon_base")

SWEP.PrintName = "Jagdbogen"
SWEP.Category = "Legendäre Waffen"
SWEP.Purpose = "Die Jagd beginnt."
SWEP.Spawnable = true

SWEP.ViewModelFOV = 68
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_huntingbow.mdl"
SWEP.WorldModel = Model("models/weapons/w_huntingbow.mdl")

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "arrows"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.UseHands = true
SWEP.IsGun = true

SWEP.STATE_NONE = 0
SWEP.STATE_NOCKED = 1
SWEP.STATE_PULLED = 2
SWEP.STATE_RELEASE = 3

SWEP.ActivitySound = {}
SWEP.ActivitySound[ACT_VM_PULLBACK] = "Weapon_HuntingBow.Pull"
SWEP.ActivitySound[ACT_VM_PRIMARYATTACK] = "Weapon_HuntingBow.Single"
SWEP.ActivitySound[ACT_VM_LOWERED_TO_IDLE] = "Weapon_HuntingBow.Nock"
SWEP.ActivitySound[ACT_VM_DRAW] = "Weapon_HuntingBow.Draw"
SWEP.ActivitySound[ACT_VM_RELEASE] = "Weapon_HuntingBow.Pull"

SWEP.ActivityLength = {}
SWEP.ActivityLength[ACT_VM_PULLBACK] = 0.2
SWEP.ActivityLength[ACT_VM_PRIMARYATTACK] = 0.25
SWEP.ActivityLength[ACT_VM_DRAW] = 0.3
SWEP.ActivityLength[ACT_VM_RELEASE] = 0.5
SWEP.ActivityLength[ACT_VM_LOWERED_TO_IDLE] = 1.25
SWEP.ActivityLength[ACT_VM_IDLE_TO_LOWERED] = 0.25

SWEP.HoldTypeTranslate = {}
SWEP.HoldTypeTranslate[SWEP.STATE_NONE] = "normal"
SWEP.HoldTypeTranslate[SWEP.STATE_NOCKED] = "revolver"
SWEP.HoldTypeTranslate[SWEP.STATE_PULLED] = "revolver"
SWEP.HoldTypeTranslate[SWEP.STATE_RELEASE] = "normal"

game.AddAmmoType {
	name = "arrows"
}

if CLIENT then
	language.Add("arrows_ammo", "Pfeile")
end

sound.Add {
	channel = CHAN_AUTO,
	volume = 0.2,
	level = 60,
	name = "Weapon_HuntingBow.Draw",
	sound = {"weapons/huntingbow/draw_1.wav", "weapons/huntingbow/draw_2.wav"}
}

sound.Add {
	channel = CHAN_AUTO,
	volume = 0.4,
	level = 60,
	name = "Weapon_HuntingBow.Nock",
	sound = {"weapons/huntingbow/nock_1.wav", "weapons/huntingbow/nock_2.wav", "weapons/huntingbow/nock_3.wav"}
}

sound.Add {
	channel = CHAN_AUTO,
	volume = 0.3,
	level = 60,
	name = "Weapon_HuntingBow.Pull",
	sound = {"weapons/huntingbow/pull_1.wav", "weapons/huntingbow/pull_2.wav", "weapons/huntingbow/pull_3.wav"}
}

sound.Add {
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	name = "Weapon_HuntingBow.Single",
	sound = {"weapons/huntingbow/shoot_1.wav", "weapons/huntingbow/shoot_2.wav", "weapons/huntingbow/shoot_3.wav"}
}

sound.Add {
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	name = "Weapon_HuntingBow.ZoomIn",
	sound = "weapons/huntingbow/zoomin.wav"
}

sound.Add {
	channel = CHAN_AUTO,
	volume = 1,
	level = 60,
	name = "Weapon_HuntingBow.ZoomOut",
	sound = "weapons/huntingbow/zoomout.wav"
}

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "State")
end

function SWEP:Deploy()
	if CLIENT then
		self.AimMult = 0
		self.AimMult2 = 0
	end
	self:SetState(self.STATE_NONE)
	self:PlayActivity(ACT_VM_DRAW)
	return true
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:PlayActivity(act)
	self:SendWeaponAnim(act)
	local snd = self.ActivitySound[act]
	if snd then
		self:EmitSound(snd)
	end
	local t = self.ActivityLength[act]
	if t then
		self:SetNextPrimaryFire(CurTime() + t)
	end
end

function SWEP:Ammo1()
	return self.Owner:GetAmmoCount(self:GetPrimaryAmmoType())
end

SWEP.ShakeBeginTime = 4
SWEP.ShakeLength = 5

SWEP.ShakeX = 0
SWEP.ShakeY = 0

local sin, cos = math.sin, math.cos
function SWEP:Think()
	local CT = CurTime()
	local nextfire = self:GetNextPrimaryFire()
	if self:GetState() == self.STATE_PULLED then
		local stamina  = math.Clamp(CT - self:GetNextSecondaryFire() - self.ShakeBeginTime, 0, self.ShakeLength) / self.ShakeLength
		local stamina2 = 1 - stamina ^ 3
		self.ShakeX = sin(CT * 3) * 0.6 * stamina + sin(CT * 64) * 0.2 * stamina ^ 3
		self.ShakeY = cos(CT * 2 + 45) * 0.6 * stamina + sin(CT * 58 + 45) * 0.2 * stamina ^ 3
	else
		self.ShakeX = 0
		self.ShakeY = 0
	end
	local holdtype = self.HoldTypeTranslate[self:GetState()]
	if holdtype != self:GetHoldType() then
		self:SetHoldType(holdtype)
	end
	if nextfire >= CT then return end
	if self:GetState() == self.STATE_PULLED then
		if self.Owner:KeyDown(IN_RELOAD) or self:Ammo1() <= 0 then
			self:SetState(self.STATE_NOCKED)
			self:PlayActivity(ACT_VM_RELEASE)
		elseif !self.Owner:KeyDown(IN_ATTACK) then
			self:SetState(self.STATE_RELEASE)
			self:PlayActivity(ACT_VM_PRIMARYATTACK)
			if SERVER then
				local ang = self.Owner:GetAimVector():Angle()
				ang:RotateAroundAxis(ang:Right(), self.ShakeY * math.pi * 2 + 2)
				ang:RotateAroundAxis(ang:Up(), self.ShakeX * math.pi * 2 + 0.1)
				local pos = self.Owner:EyePos() + ang:Up() * -7 + ang:Forward() * -4
				if !self.Owner:KeyDown(IN_ATTACK2) then
					pos = pos + ang:Right() * 1.5
				end
				local charge = self:GetNextSecondaryFire()
				charge = math.Clamp(CT - charge, 0, 1)
				local arrow = ents.Create("huntingbow_arrow")
				if !IsValid(arrow) then return end
				arrow:SetOwner(self.Owner)
				arrow:SetPos(pos)
				arrow:SetAngles(ang)
				arrow:Spawn()
				arrow:Activate()
				arrow:SetVelocity(ang:Forward() * 3000 * charge)
				arrow.Weapon = self
				self:TakePrimaryAmmo(1)
			end
		end
	elseif self:GetState() == self.STATE_RELEASE then
		if self.Owner:KeyDown(IN_ATTACK) and self:Ammo1() > 0 then
			self:SetState(self.STATE_NOCKED)
			self:PlayActivity(ACT_VM_LOWERED_TO_IDLE)
		else
			self:SetState(self.STATE_NONE)
			self:PlayActivity(ACT_VM_IDLE_TO_LOWERED)
		end
	elseif self:GetState() == self.STATE_NOCKED then
		if self.Owner:KeyDown(IN_ATTACK) and !self.Owner:KeyDown(IN_RELOAD) then
			self:SetState(self.STATE_PULLED)
			self:PlayActivity(ACT_VM_PULLBACK)
			self:SetNextSecondaryFire(CT)
		end
	elseif self:GetState() == self.STATE_NONE then
		if (self.Owner:KeyDown(IN_RELOAD) or self.Owner:KeyPressed(IN_ATTACK)) and self:Ammo1() > 0 then
			self:SetState(self.STATE_NOCKED)
			self:PlayActivity(ACT_VM_LOWERED_TO_IDLE)
		end
	end
end