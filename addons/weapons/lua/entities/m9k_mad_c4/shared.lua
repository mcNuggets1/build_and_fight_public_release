ENT.PrintName = "Placed C4"
ENT.Type = "anim"

function ENT:SetupDataTables()  
	self:NetworkVar("Int", 0, "Timer")
end 

function ENT:Initialize()
	self.C4CountDown = self:GetTimer() or 0
	self:EmitSound("C4.Plant")
	self.FirstCall = true
	self:CountDown()
end

function ENT:CountDown()
	if self.C4CountDown > 1 then
		if !self.FirstCall then
			self:EmitSound("C4.PlantSound")
		else
			self.FirstCall = false
		end
		self.C4CountDown = self.C4CountDown - 1
		timer.Create("CountDown_"..self:EntIndex(), 1, 0, function()
			if !IsValid(self) then return end
			self:CountDown()
		end)
	else
		self.C4CountDown = 0
		timer.Remove("CountDown_"..self:EntIndex())
	end
end

function ENT:OnRemove()
	timer.Remove("CountDown_"..self:EntIndex())
end

if SERVER then
	AddCSLuaFile("shared.lua")

	function ENT:Initialize()
		self:SetModel("models/weapons/w_sb_planted.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
		end
		self:SetHealth(250)
		self:SetTimer(self.Timer + 1)
		self.ThinkTimer = CurTime() + self.Timer + 1 or 10
		self.CanExplode = true
	end

	function ENT:Think()
		if !IsValid(self.Owner) then
			self:Remove()
			return
		end
		if self.ThinkTimer < CurTime() then
			self:Explosion()
		end
	end

	local c4_explosion = Sound("C4.Explode")
	function ENT:Explosion()
		if !self.CanExplode then return end
		self.CanExplode = false
		local pos = self:GetPos()
		local edata = EffectData()
		edata:SetOrigin(pos)
		edata:SetNormal(self.Normal and -self.Normal or Vector(0, 0, 1))
		edata:SetEntity(self)
		edata:SetScale(2.5)
		edata:SetRadius(25)
		edata:SetMagnitude(25)
		util.Effect("m9k_gdcw_cinematicboom", edata, true, true)
		util.Decal("Scorch", pos, pos - Vector(0, 0, 10))
		util.BlastDamage(self, self.Owner, pos, 750, 500)
		util.ScreenShake(pos, 25, 255, 2, 2500)
		self:EmitSound(c4_explosion)
		self:Remove()
	end

	function ENT:OnTakeDamage(dmginfo)
		self:TakePhysicsDamage(dmginfo)
		self:SetHealth(self:Health() - dmginfo:GetDamage())
		if self:Health() <= 0 then
			self:Explosion()
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
		local FixAngles = self:GetAngles()
		local FixRotation = Vector(0, 276, 0)
		FixAngles:RotateAroundAxis(FixAngles:Right(), FixRotation.x)
		FixAngles:RotateAroundAxis(FixAngles:Up(), FixRotation.y)
		FixAngles:RotateAroundAxis(FixAngles:Forward(), FixRotation.z)
 		local TargetPos = self:GetPos() + (self:GetUp() * 7) + (self:GetRight() * -.5) + (self:GetForward() * 1.15)
		local m, s = self:FormatTime(self.C4CountDown)
		self.Text = string.format("%02d", m)..":"..string.format("%02d", s)
		cam.Start3D2D(TargetPos, FixAngles, 0.07)
			draw.SimpleText(self.Text, "CloseCaption_Normal", 31, -22, Color(165, 0, 0, 255), 1, 1)
		cam.End3D2D() 
	end

	function ENT:FormatTime(seconds)
		local m = seconds % 604800 % 86400 % 3600 / 60
		local s = seconds % 604800 % 86400 % 3600 % 60
		return math.floor(m), math.floor(s)
	end
end