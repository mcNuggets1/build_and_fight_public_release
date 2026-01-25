SWEP.Category = "M9K Specialties"
SWEP.DrawWeaponInfoBox = true
SWEP.AutoInsertInfo = false
SWEP.Instructions = "Primary Fire: Plant."
SWEP.PrintName = "Proxy Mine"
SWEP.Slot = 4
SWEP.SlotPos = 5
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Weight = 70
SWEP.HoldType = "slam"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_px.mdl"
SWEP.WorldModel = Model("models/weapons/w_px.mdl")
SWEP.Base = "mg_gun_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("")
SWEP.Primary.RPM = 10
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Round = "m9k_proxy"
SWEP.CanAim = false
SWEP.CanLower = false
SWEP.RunHoldType = "normal"
SWEP.RunSightsPos = Vector(0, 0, -2)
SWEP.RunSightsAng = Vector(0, 0, 0)

function SWEP:AddInit()
	if SERVER then
		self:SetNW2Bool("Planting", false)
	end
end

function SWEP:AddDeploy()
	if SERVER then
		self:SetNW2Bool("Planting", false)
		timer.Remove("ProxyDeploy_"..self:EntIndex(), self:SequenceDuration())
	end
end

function SWEP:AddHolster()
	if SERVER then
		self:SetNW2Bool("Planting", false)
		timer.Remove("ProxyDeploy_"..self:EntIndex(), self:SequenceDuration())
	end
end

function SWEP:PrimaryAttack()
	if !SERVER or self:GetNW2Bool("Planting") then return end
	self:SetNW2Bool("Planting", true)
	self:SetNextPrimaryFire(CurTime() + 3)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	timer.Create("ProxyDeploy_"..self:EntIndex(), self:SequenceDuration(), 1, function()
		if IsValid(self) and IsValid(self.Owner) then
			self.Planted = true
			local tr = {}
			tr.start = self.Owner:GetShootPos()
			tr.endpos = self.Owner:GetShootPos() + 100 * self.Owner:EyeAngles():Forward()
			tr.filter = {self.Owner}
			local trace = util.TraceLine(tr)
			local prox = ents.Create(self.Primary.Round)
			if !IsValid(prox) then return end
			prox:SetPos(trace.HitPos)
			prox.Normal = trace.Hit and -trace.HitNormal
			trace.HitNormal.z = -trace.HitNormal.z
			prox:SetAngles(trace.HitNormal:Angle() - Angle(90, 180, 0))
			prox.Owner = self.Owner
			prox:Spawn()
			if trace.Entity and IsValid(trace.Entity) then
				if IsValid(trace.Entity:GetPhysicsObject()) and !trace.Entity:IsPlayer() then
					prox:SetParent(trace.Entity)
				elseif !trace.Entity:IsPlayer() and IsValid(trace.Entity:GetPhysicsObject()) then
					constraint.Weld(prox, trace.Entity, 0, 0, 0, false, false)
				end
			else
				prox:SetMoveType(MOVETYPE_NONE)
			end
			if !trace.Hit then
				prox:SetMoveType(MOVETYPE_VPHYSICS)
			end
			self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
			self.Owner:SetAnimation(PLAYER_ATTACK1)
			self:CheckWeaponsAndAmmo(self:SequenceDuration() * 0.75)
			self.Planted = true
		end
	end)
end

function SWEP:CheckWeaponsAndAmmo(Wait)
	timer.Simple(Wait, function() 
		if IsValid(self) then 
			MG_RemoveWeapon(self)
		end
	end)
end