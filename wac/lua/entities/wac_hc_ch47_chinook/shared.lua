if not wac then return end
AddCSLuaFile()

ENT.Base 				= "wac_hc_base"
ENT.Type 				= "anim"
ENT.PrintName			= "CH-47 Chinook"
ENT.Author				= "}{ornet/Vest,SentrySappinMySpy,Reality Mod"
ENT.Category			= wac.aircraft.spawnCategoryC
ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.Model			= "models/wac/ch47b.mdl"
ENT.EngineForce	= 40
ENT.Weight		= 50000
ENT.SmokePos		= Vector(-178,0,189)
ENT.FirePos		= Vector(-178,0,189)

ENT.TopRotor = {
	dir = -1,
	pos = Vector(288,0,181),
	model = "models/wac/chinookbladerr.mdl"
}

ENT.TopRotor2 = {
	dir = 1,
	pos = Vector(-246,0,247),
	angles = Angle(0,0,0),
	model = "models/wac/chinookbladef.mdl"
}

ENT.BackRotor = {
	dir = 1,
	pos = Vector(0,0,43),
	model = "models/props_junk/PopCan01a.mdl"
}

ENT.thirdPerson = {
	distance = 700
}

ENT.Wheels={
	{
		mdl="models/BF2/helicopters/Mil Mi-28/mi28_w1.mdl",
		pos=Vector(-204,-74,32),
		friction=100,
		mass=400,
	},
	{
		mdl="models/BF2/helicopters/Mil Mi-28/mi28_w1.mdl",
		pos=Vector(-204,73,32),
		friction=100,
		mass=400,
	},
	{
		mdl="models/BF2/helicopters/Mil Mi-28/mi28_w1.mdl",
		pos=Vector(104,-71.8,16),
		friction=100,
		mass=400,
	},
	{
		mdl="models/BF2/helicopters/Mil Mi-28/mi28_w1.mdl",
		pos=Vector(104,72,16),
		friction=100,
		mass=400,
	},
	{
		mdl="models/BF2/helicopters/Mil Mi-28/mi28_w1.mdl",
		pos=Vector(104,-56,16),
		friction=100,
		mass=400,
	},
	{
		mdl="models/BF2/helicopters/Mil Mi-28/mi28_w1.mdl",
		pos=Vector(104,56.3,16),
		friction=100,
		mass=400,
	},
}

ENT.Seats = {
	{
		pos=Vector(284, -29, 77),
		exit=Vector(195,0,50),
	},
	{
		pos=Vector(284, 30, 77),
		exit=Vector(195,0,50),
	},
	{
		pos=Vector(110, -45, 65),
		exit=Vector(110,0,50),
		ang=Angle(0,90,0),
	},
	{
		pos=Vector(40, -45, 65),
		exit=Vector(40,0,50),
		ang=Angle(0,90,0),
	},
	{
		pos=Vector(-50, -45, 65),
		exit=Vector(-50,0,50),
		ang=Angle(0,90,0),
	},
	{
		pos=Vector(-50, 45, 65),
		exit=Vector(-50,0,50),
		ang=Angle(0,-90,0),
	},
	{
		pos=Vector(40, 45, 65),
		exit=Vector(40,0,50),
		ang=Angle(0,-90,0),
	},
	{
		pos=Vector(115, 45, 65),
		exit=Vector(115,0,50),
		ang=Angle(0,-90,0),
	},
	{
		pos=Vector(-115, 45, 65),
		exit=Vector(-115,0,50),
		ang=Angle(0,-90,0),
	},
}

ENT.Sounds={
	Start="WAC/ch46/start.wav",
	Blades="WAC/ch47/external.wav",
	Engine="WAC/ch47/internal.wav",
	MissileAlert="HelicopterVehicle/MissileNearby.mp3",
	MissileShoot="HelicopterVehicle/MissileShoot.mp3",
	MinorAlarm="HelicopterVehicle/MinorAlarm.mp3",
	LowHealth="HelicopterVehicle/LowHealth.mp3",
	CrashAlarm="HelicopterVehicle/CrashAlarm.mp3",
}

function ENT:SpawnFunction(ply, tr)
	if (!tr.Hit) then return end
	local ent=ents.Create(ClassName)
	ent:SetPos(tr.HitPos+tr.HitNormal*200)
	ent.Owner=ply
	ent:Spawn()
	ent:Activate()
	local i = 0
	hook.Add("Think", "", function()
		if i > 33 then return end
		i = i + 1
		if ent == NULL then return end
		ent:SetAngles(Angle(0, 0, 0))
	end)
	return ent
end

if SERVER then
	function ENT:addRotors()
		self:base("wac_hc_base").addRotors(self)
		self.topRotor2 = self:addEntity("prop_physics")
		self.topRotor2:SetModel("models/props_junk/sawblade001a.mdl")
		self.topRotor2:SetPos(self:LocalToWorld(self.TopRotor2.pos))
		self.topRotor2:SetAngles(self:LocalToWorldAngles(self.TopRotor2.angles))
		self.topRotor2:SetOwner(self.Owner)
		self.topRotor2:SetNotSolid(true)
		self.topRotor2:Spawn()
		self.topRotor2.Phys = self.topRotor2:GetPhysicsObject()
		self.topRotor2.Phys:EnableGravity(false)
		self.topRotor2.Phys:SetMass(5)
		self.topRotor2.Phys:EnableDrag(false)
		self.topRotor2:SetNoDraw(true)
		self.topRotor2.fHealth = 100
		self.topRotor2.wac_ignore = true
		if self.TopRotor2.model then
			local e = self:addEntity("wac_hitdetector")
			self:SetNWEntity("wac_air_rotor_main", e)
			e:SetModel(self.TopRotor2.model)
			e:SetPos(self.topRotor2:GetPos())
			e:SetAngles(self.topRotor2:GetAngles())
			e:Spawn()
			e:SetNotSolid(true)
			e:SetParent(self.topRotor2)
			e.wac_ignore = true
			local obb = e:OBBMaxs()
			self.RotorWidth2 = (obb.x>obb.y and obb.x or obb.y)
			self.RotorHeight2 = obb.z
			self.topRotor2.vis = e
		end
		constraint.Axis(self.Entity, self.topRotor2, 0, 0, self.TopRotor2.pos, Vector(0,0,1), 0,0,0,1)
		self:AddOnRemove(self.topRotor2)
	end

	function ENT:PhysicsUpdate(ph)
		self:base("wac_hc_base").PhysicsUpdate(self,ph)		
			
		local vel = ph:GetVelocity()	
		local pos = self:GetPos()
		local ri = self:GetRight()
		local up = self:GetUp()
		local fwd = self:GetForward()
		local ang = self:GetAngles()
		local dvel = vel:Length()
		local lvel = self:WorldToLocal(pos+vel)

		local pilot = self.passengers[1]

		local hover = self:calcHover(ph,pos,vel,ang)
		
		local rotateX = (self.controls.roll*1.5+hover.r)*self.rotorRpm
		local rotateY = (self.controls.pitch+hover.p)*self.rotorRpm
		local rotateZ = self.controls.yaw*1.5*self.rotorRpm
		
		--local phm = (wac.aircraft.cvars.doubleTick:GetBool() and 2 or 1)
		local phm = FrameTime()*66
		if self.UsePhysRotor then
			if self.topRotor2 and self.topRotor2.Phys and self.topRotor2.Phys:IsValid() then
				if self.RotorBlurModel then
					self.topRotor2.vis:SetColor(Color(255,255,255,math.Clamp(1.3-self.rotorRpm,0.1,1)*255))
				end

				-- top rotor physics
				local rotor = {}
				rotor.phys = self.topRotor2.Phys
				rotor.angVel = rotor.phys:GetAngleVelocity()
				rotor.upvel = self.topRotor2:WorldToLocal(self.topRotor2:GetVelocity()+self.topRotor2:GetPos()).z
				rotor.brake =
					math.Clamp(math.abs(rotor.angVel.z) - 2950, 0, 100)/10 -- RPM cap
					+ math.pow(math.Clamp(1500 - math.abs(rotor.angVel.z), 0, 1500)/900, 3)
					+ math.abs(rotor.angVel.z/10000)
					- (rotor.upvel - self.rotorRpm)*self.controls.throttle/1000

				rotor.targetAngVel =
					Vector(0, 0, math.pow(self.engineRpm,2)*self.TopRotor2.dir*10)
					- rotor.angVel*rotor.brake/200

				rotor.phys:AddAngleVelocity(rotor.targetAngVel)
			end
		end
		self.LastPhys = CurTime()
	end
end

function ENT:DrawWeaponSelection() end