SWEP.Category = "M9K Specialties"
SWEP.DrawWeaponInfoBox = true
SWEP.AutoInsertInfo = false
SWEP.Instructions = "Primary Fire: Mark a position to order an orbital strike."
SWEP.PrintName = "Orbital Strike Marker"
SWEP.Slot = 4
SWEP.SlotPos = 5
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Weight = 70
SWEP.HoldType = "camera"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_invisib.mdl"	
SWEP.WorldModel = Model("models/weapons/w_binos.mdl")
SWEP.Base = "mg_sniper_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("weapons/satellite/targaquired.mp3")
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Secondary.ScopeZoom = 5
SWEP.Secondary.UseMilDot = true
SWEP.ScopeScale = 1
SWEP.CanLower = false
SWEP.RunHoldType = "normal"
SWEP.SightsPos = Vector(-3.589, -8.867, -4.124)
SWEP.SightsAng = Vector(50.353, 17.884, -19.428)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-21.994, 0, 0)
SWEP.Targeted = false

SWEP.ViewModelBoneMods = {
	["l-ring-low"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-19.507, 0, 0)},
	["r-index-mid"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-71.792, 0, 0)},
	["r-middle-low"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-21.483, 1.309, 0)},
	["l-upperarm-movement"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, -0.88), angle = Angle(0, 0, 0)},
	["Da Machete"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0.263, -1.826), angle = Angle(0, 0, 0)},
	["r-ring-low"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-17.507, 0, 0)},
	["r-pinky-mid"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-47.32, 0, 0)},
	["r-ring-mid"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-54.065, 0, 0)},
	["r-index-low"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-49.646, 0, 0)},
	["r-thumb-tip"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-17.666, 0, 0)},
	["r-upperarm-movement"] = {scale = Vector(1, 1, 1), pos = Vector(7.394, 2.101, -9.54), angle = Angle(-10.502, -12.632, 68.194)},
	["r-pinky-low"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-21.526, 0, 0)},
	["r-middle-mid"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-37.065, 0, 0)},
	["r-thumb-mid"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-4.816, 18.775, -30.143)},
	["l-index-low"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-49.646, 0, 0)},
	["r-thumb-low"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-0.982, 0, 0)}
}

SWEP.VElements = {
	["binos"] = {type = "Model", model = "models/weapons/binos.mdl", bone = "r-thumb-low", rel = "", pos = Vector(3.907, -0.109, -1.125), angle = Angle(-2.829, 27.281, 105.791), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}}
}

function SWEP:PrimaryAttack()
	if !self:GetRunning() and !self:GetPredictedRunning() then
		self:SetNextPrimaryFire(CurTime() + 1)
		self.Targeted = false
		local mark = self.Owner:GetEyeTrace()
		if mark.HitSky then 
			self.Owner:EmitSound("player/suit_denydevice.wav")
		end
		local skytrace = {}
		skytrace.start = mark.HitPos
		skytrace.endpos = mark.HitPos + Vector(0,0,65000)
		skycheck = util.TraceLine(skytrace)
		if skycheck.HitSky then
			if SERVER then
				local sky = skycheck.HitPos - Vector(0,0,10)
				local ground = mark.HitPos
				local sat = ents.Create("m9k_oribital_cannon")
				if !IsValid(sat) then return end
				sat.Ground = ground
				sat.Sky = sky
				sat.Owner = self.Owner
				sat:SetPos(sky)
				sat:Spawn()
			end
			self.Owner:EmitSound(self.Primary.Sound)
			self:TakePrimaryAmmo(1)
			if SERVER then
				self:CheckWeaponsAndAmmo(0.25)
			end
		elseif mark.Entity:IsPlayer() or mark.Entity:IsNPC() then
			self.Targeted = true
			local target = mark.Entity
			local skytrace = {}
			skytrace.start = target:GetPos()
			skytrace.endpos = target:GetPos() + Vector(0,0,65000)
			skytrace.filter = target
			skycheck = util.TraceLine(skytrace)
			if skycheck.HitSky then
				local sky = skycheck.HitPos - Vector(0,0,10)
				if SERVER then
					local sat = ents.Create("m9k_oribital_cannon")
					if !IsValid(sat) then return end
					sat.Targeted = true
					sat.Target = target
					sat.Sky = sky
					sat.Owner = self.Owner
					sat:SetPos(sky)
					sat:Spawn()
				end
				self.Owner:EmitSound(self.Primary.Sound)
				self:TakePrimaryAmmo(1)
				if SERVER then
					self:CheckWeaponsAndAmmo(0.25)
				end
			else
				self:EmitSound("player/suit_denydevice.wav")
			end
		else
			self:EmitSound("player/suit_denydevice.wav")
		end
	end
end

function SWEP:CheckWeaponsAndAmmo(Wait)
	timer.Simple(Wait, function()
		if !IsValid(self) then return end
		MG_RemoveWeapon(self)
	end)
end

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end