SWEP.Category = "M9K Specialties"
SWEP.DrawWeaponInfoBox = true
SWEP.AutoInsertInfo = false
SWEP.Instructions = "Primary fire: Plant C4.\nSecondary fire: Change time."
SWEP.PrintName = "C4"
SWEP.Slot = 4
SWEP.SlotPos = 5
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = false
SWEP.Weight = 70
SWEP.HoldType = "slam"
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_c4.mdl"
SWEP.WorldModel = Model("models/weapons/w_c4.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("")
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Round = "m9k_planted_c4"
SWEP.CanAim = false
SWEP.CanRun = true
SWEP.CanLower = false
SWEP.RunHoldType = "normal"
SWEP.RunSightsPos = Vector(0, 0, -5)
SWEP.RunSightsAng = Vector(0, 0, 0)
SWEP.Timer = 30

SWEP.ThirtySecondsSelected = "30 seconds selected."
SWEP.FortyFiveSecondsSelected = "45 seconds selected."
SWEP.SixtySecondsSelected = "60 seconds selected."
SWEP.HundredTwentySecondsSelected = "120 seconds selected."

function SWEP:AddInit()
	if SERVER then
		self:SetNW2Bool("Planting", false)
	end
end

function SWEP:AddDeploy()
	if SERVER then
		self:SetNW2Bool("Planting", false)
		timer.Remove("C4Deploy_"..self:EntIndex(), self:SequenceDuration())
	end
end

function SWEP:AddHolster()
	if SERVER then
		self:SetNW2Bool("Planting", false)
		timer.Remove("C4Deploy_"..self:EntIndex(), self:SequenceDuration())
	end
end

function SWEP:PrimaryAttack()
	if !SERVER or self:GetNW2Bool("Planting") then return end
	self:SetNW2Bool("Planting", true)
	self:SetNextPrimaryFire(CurTime() + 3)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + 100 * self.Owner:GetAimVector()
	tr.filter = {self.Owner}
	timer.Create("C4Deploy_"..self:EntIndex(), self:SequenceDuration(), 1, function()
		if IsValid(self) and IsValid(self.Owner) then
			local tr = {}
			tr.start = self.Owner:GetShootPos()
			tr.endpos = self.Owner:GetShootPos() + 100 * self.Owner:GetAimVector()
			tr.filter = {self.Owner}
			local trace = util.TraceLine(tr)
			local C4 = ents.Create(self.Primary.Round)
			if !IsValid(C4) then return end
			C4:SetPos(trace.HitPos)
			C4.Normal = trace.Hit and -trace.HitNormal
			trace.HitNormal.z = -trace.HitNormal.z
			C4:SetAngles(trace.HitNormal:Angle() - Angle(90, 180, 0))
			C4.Owner = self.Owner
			C4.Timer = self.Timer
			C4:Spawn()
			if IsValid(trace.Entity) then
				if !trace.Entity:IsPlayer() and IsValid(trace.Entity:GetPhysicsObject()) then
					constraint.Weld(C4, trace.Entity, 0, 0, 0, collision == 1, false)
				end
			else
				C4:SetMoveType(MOVETYPE_NONE)
			end
			if !trace.Hit then
				C4:SetMoveType(MOVETYPE_VPHYSICS)
			end
			self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
			self.Owner:SetAnimation(PLAYER_ATTACK1)
			self:CheckWeaponsAndAmmo(self:SequenceDuration() * 0.75)
		end
	end)
end

function SWEP:SecondaryAttack()
	if !IsValid(self.Owner) or !IsFirstTimePredicted() or self:GetNW2Bool("Planting") then return end
	self:EmitSound("C4.PlantSound")
	self:SetNextPrimaryFire(CurTime() + 0.1)
	self:SetNextSecondaryFire(CurTime() + 0.1)
	if !SERVER then return end
	if self.Timer == 30 then
		self.Owner:PrintMessage(HUD_PRINTTALK, "45 Sekunden eingestellt.")
		self.Timer = 45
	elseif self.Timer == 45 then
		self.Owner:PrintMessage(HUD_PRINTTALK, "60 Sekunden eingestellt.")
		self.Timer = 60
	elseif self.Timer == 60 then
		self.Owner:PrintMessage(HUD_PRINTTALK, "120 Sekunden eingestellt.")
		self.Timer = 120
	elseif self.Timer == 120 then
		self.Owner:PrintMessage(HUD_PRINTTALK, "30 Sekunden eingestellt.")
		self.Timer = 30
	end
end

function SWEP:CheckWeaponsAndAmmo(Wait)
	timer.Simple(Wait, function() 
		if IsValid(self) then 
			MG_RemoveWeapon(self)
		end
	end)
end