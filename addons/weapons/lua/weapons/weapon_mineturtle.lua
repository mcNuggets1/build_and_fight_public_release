SWEP.PrintName = "Schildkrötenmine"
SWEP.Purpose = "Oh schau mal, eine Schildkröte!"
SWEP.Instructions = "Linksklick: Schildkrötenmine davon werfen.\nRechtsklick: Schildkrötenmine platzieren."
SWEP.Author = "Modern Gaming"
SWEP.Base = "weapon_basekit"
SWEP.Slot = 4
SWEP.SlotPos = 5
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModel = "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel = Model("models/weapons/w_grenade.mdl")
SWEP.ShowWorldModel = false
SWEP.HoldType = "slam"
SWEP.Category = "Legendäre Waffen"
SWEP.Spawnable = true
SWEP.UseHands = true
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Ammo = ""
SWEP.Primary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = ""
SWEP.Secondary.Automatic = false
SWEP.InitSound = Sound("turtlegrenade/hello_mineturtle.wav")
SWEP.IsGun = true

SWEP.ViewModelBoneMods = {
	["v_weapon.Flashbang_Parent"] = {scale = Vector(0.1, 0.1, 0.1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0)},
	["ValveBiped.Bip01_R_Finger0"] = {scale = Vector(1, 1, 1), pos = Vector(-1.297, 0.185, -0.926), angle = Angle(-10, 0, 0)},
	["ValveBiped.Bip01_R_Finger01"] = {scale = Vector(1, 1, 1), pos = Vector(0.185, 0, 0.4), angle = Angle(0, 0, 0)},
	["ValveBiped.Bip01_R_Finger02"] = {scale = Vector(1, 1, 1), pos = Vector(0.5, 0, 0.4), angle = Angle(0, 0, 0)},
	["ValveBiped.Bip01_R_Finger1"] = {scale = Vector(1, 1, 1), pos = Vector(1.296, 0, 0), angle = Angle(0, 0, 0)},
	["ValveBiped.Bip01_R_Finger11"] = {scale = Vector(1, 1, 1), pos = Vector(0.555, 0, 0), angle = Angle(0, 0, 0)},
	["ValveBiped.Bip01_R_Finger2"] = {scale = Vector(1, 1, 1), pos = Vector(2.036, 0, 0), angle = Angle(0, 0, 0)},
	["ValveBiped.Bip01_R_Finger3"] = {scale = Vector(1, 1, 1), pos = Vector(2.407, 0, 0), angle = Angle(0, 0, 0)},
	["ValveBiped.Bip01_R_Finger4"] = {scale = Vector(1, 1, 1), pos = Vector(0.925, -0.186, 0), angle = Angle(0, 0, 0)},
	["ValveBiped.Bip01_L_Clavicle"] = {scale = Vector(1, 1, 1), pos = Vector(0, 0, -1000), angle = Angle(0, 0, 0)},
}
SWEP.VElements = {
	["v_mineturtle"] = {type = "Model", model = "models/props/de_tides/vending_turtle.mdl", bone = "v_weapon.pull_ring", rel = "", pos = Vector(-1, -2, 1.5), angle = Angle(170, 90, 90), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["w_mineturtle"] = {type = "Model", model = "models/props/de_tides/vending_turtle.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 3.5, 0), angle = Angle(180, 180, 90), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

DEFINE_BASECLASS("weapon_basekit")

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:SetDeploySpeed(1)
	BaseClass.Initialize(self)
end

function SWEP:Deploy()
	timer.Remove("PlaceTurtle_"..self:EntIndex())
	self:EmitSound(self.InitSound)
	return true
end

function SWEP:ThrowTurtle(time)
	self:Throw()
	timer.Simple(time, function() 
		if IsValid(self) and IsValid(self.Owner) then
			self.Owner:StripWeapon(self.ClassName)
		end
	end)
end

function SWEP:PlaceTurtle(time)
	self:Place()
	timer.Simple(time, function() 
		if IsValid(self) and IsValid(self.Owner) then
			self.Owner:StripWeapon(self.ClassName)
		end
	end)
end

function SWEP:PrimaryAttack()
	if !IsValid(self.Owner) then return end
	self:SendWeaponAnim(ACT_VM_THROW)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)
	if SERVER then
		timer.Create("PlaceTurtle_"..self:EntIndex(), 0.25, 1, function()
			if !IsValid(self) or !IsValid(self.Owner) then return end
			self:ThrowTurtle(self:SequenceDuration() * 0.6)
		end)
	end
end

function SWEP:SecondaryAttack()
	if !IsValid(self.Owner) then return end
	self:SendWeaponAnim(ACT_VM_THROW)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)
	if SERVER then
		timer.Create("PlaceTurtle_"..self:EntIndex(), 0.25, 1, function()
			if !IsValid(self) or !IsValid(self.Owner) then return end
			self:PlaceTurtle(self:SequenceDuration() * 0.6)
		end)
	end
end

function SWEP:Throw()
	if !SERVER then return end
	local aim = self.Owner:GetAimVector()
	local side = aim:Cross(Vector(0, 0, 1))
	local up = side:Cross(aim)
	local turtle = ents.Create("mineturtle")
	if !IsValid(turtle) then return end
	turtle:SetPos(self.Owner:GetShootPos() + side * 15 + up * -1)
	turtle:SetAngles(aim:Angle() + Angle(90, 0, 0))
	turtle.Owner = self.Owner
	turtle:Spawn()
	turtle:Activate()
	local phys = turtle:GetPhysicsObject()
	if IsValid(turtle) then
		phys:ApplyForceCenter(self.Owner:GetAimVector() * 1000 + Vector(0, 0, 200))
		phys:AddAngleVelocity(VectorRand() * 1000)
	end
end

function SWEP:Place()
	if !SERVER then return end
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + 100 * self.Owner:GetAimVector()
	tr.filter = {self.Owner}
	local trace = util.TraceLine(tr)
	local turtle = ents.Create("mineturtle")
	if !IsValid(turtle) then return end
	turtle:SetPos(trace.HitPos)
	if !trace.Hit then
		local eye = self.Owner:EyeAngles()
		turtle:SetAngles(Angle(0, eye[2], eye[3]))
	else
		trace.HitNormal.z = -trace.HitNormal.z
		turtle:SetAngles(trace.HitNormal:Angle() - Angle(90, 180, 0))
	end
	turtle.Owner = self.Owner
	turtle:Spawn()
	if IsValid(trace.Entity) then
		if IsValid(trace.Entity:GetPhysicsObject()) and !trace.Entity:IsPlayer() then
			turtle:SetParent(trace.Entity)
		elseif !trace.Entity:IsPlayer() and IsValid(trace.Entity:GetPhysicsObject()) then
			constraint.Weld(turtle, trace.Entity)
		end
	else
		turtle:SetMoveType(MOVETYPE_NONE)
	end
	if !trace.Hit then
		turtle:SetMoveType(MOVETYPE_VPHYSICS)
	end
end

function SWEP:Holster()
	timer.Remove("PlaceTurtle_"..self:EntIndex())
	BaseClass.Holster(self)
	return true
end

function SWEP:OnRemove()
	self:Holster()
end