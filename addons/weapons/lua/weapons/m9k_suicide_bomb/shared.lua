SWEP.Category = "M9K Specialties"
SWEP.DrawWeaponInfoBox = true
SWEP.AutoInsertInfo = false
SWEP.Instructions = "Primary Fire: Plant C4.\nSecondary Fire: Change time."
SWEP.PrintName = "C4"
SWEP.Slot = 4
SWEP.SlotPos = 5
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = false
SWEP.Weight = 70
SWEP.HoldType = "slam"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_sb.mdl"
SWEP.WorldModel = Model("models/weapons/w_sb.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("")
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Round = "m9k_mad_c4"
SWEP.CanAim = false
SWEP.CanLower = false
SWEP.RunHoldType = "normal"
SWEP.RunSightsPos = Vector(0, 0, -2)
SWEP.RunSightsAng = Vector(0, 0, 0)
SWEP.Timer = 0

SWEP.RestrictToJob = true
SWEP.RestrictJob = TEAM_TERROR
SWEP.WrongJobText = "You can't use C4 with your current job!"
SWEP.TenSecondsSelected = "10 seconds selected."
SWEP.TwentySecondsSelected = "20 seconds selected."
SWEP.ThirtySecondsSelected = "30 seconds selected."
SWEP.FourtyFiveSecondsSelected = "45 seconds selected."
SWEP.DetonationOnUseSelected = "Warning: Instant detonation configured!"

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
	if !SERVER then return end
	self:SetNextPrimaryFire(CurTime() + 1)
	if self.RestrictToJob and DarkRP then
		if (self.Owner:Team() == self.RestrictJob) then
			self:Plant()
		else
			self.Owner:PrintMessage(HUD_PRINTTALK, self.WrongJobText)
		end
	else
		self:Plant()
	end
end

function SWEP:Plant()
	if self:GetNW2Bool("Planting") then return end
	self:SetNW2Bool("Planting", true)
	self:SetNextPrimaryFire(CurTime() + 3)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + 100 * self.Owner:EyeAngles():Forward()
	tr.filter = {self.Owner}
	local trace = util.TraceLine(tr)
	timer.Create("C4Deploy_"..self:EntIndex(), self:SequenceDuration(), 1, function()
		if IsValid(self) and IsValid(self.Owner) then
			self.Planted = true
			if self.Timer != 0 then
				local tr = {}
				tr.start = self.Owner:GetShootPos()
				tr.endpos = self.Owner:GetShootPos() + 100 * self.Owner:EyeAngles():Forward()
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
						constraint.Weld(C4, trace.Entity, 0, 0, 0, false, false)
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
			else
				self:Suicide()
			end
		end
	end)
end

local c4_explode = Sound("C4.Explode")
function SWEP:Suicide()
	if SERVER then
		self:EmitSound(c4_explode)
		local edata = EffectData()
		edata:SetOrigin(self.Owner:GetPos())
		edata:SetNormal(Vector(0, 0, 1))
		edata:SetEntity(self)
		edata:SetScale(2.5)
		edata:SetRadius(85)
		edata:SetMagnitude(24)
		util.Effect("m9k_gdcw_cinematicboom", edata)
		util.BlastDamage(self, self.Owner, self:GetPos(), 500, 300)
		util.ScreenShake(self:GetPos(), 25, 255, 2.5, 2500)
		MG_RemoveWeapon(self)
	end
end

function SWEP:SecondaryAttack()
	if !IsValid(self.Owner) or !IsFirstTimePredicted() or self:GetNW2Bool("Planting") then return end
	self:EmitSound("C4.PlantSound")
	self:SetNextPrimaryFire(CurTime() + 0.1)
	self:SetNextSecondaryFire(CurTime() + 0.1)
	if !SERVER then return end
	if self.Timer == 10 then
		self.Owner:PrintMessage(HUD_PRINTTALK, self.TwentySecondsSelected)
		self.Timer = 20
	elseif self.Timer == 20 then
		self.Owner:PrintMessage(HUD_PRINTTALK, self.ThirtySecondsSelected)
		self.Timer = 30
	elseif self.Timer == 30 then
		self.Owner:PrintMessage(HUD_PRINTTALK, self.FourtyFiveSecondsSelected)
		self.Timer = 45
	elseif self.Timer == 45 then
		self.Owner:PrintMessage(HUD_PRINTTALK, self.DetonationOnUseSelected)
		self.Timer = 0
	elseif self.Timer == 0 then
		self.Owner:PrintMessage(HUD_PRINTTALK, self.TenSecondsSelected)
		self.Timer = 10
	end
end

function SWEP:CheckWeaponsAndAmmo(Wait)
	timer.Simple(Wait, function() 
		if IsValid(self) then 
			self:Remove()
			if IsValid(self.Owner) then
				self.Owner:ConCommand("lastinv")
			end
		end
	end)
end