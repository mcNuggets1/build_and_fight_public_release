include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

ENT.IgnoreDamage = true
ENT.UsephysRotor = true
ENT.Submersible	= false
ENT.CrRotorWash	= true
ENT.RotorWidth = 10
ENT.rotorDir = 1
ENT.BackRotorDir = 1
ENT.rotorPos = Vector(83, 0, 0.5)
ENT.BackRotorPos = Vector(-400, 5, 137)
ENT.Weight = 800
ENT.CrRotorWash = false

ENT.Aerodynamics = {
	Rotation = {
		Front = Vector(0, 0, 0),
		Right = Vector(0, 0, 50), -- Rotate towards flying direction
		Top = Vector(0, -50, 0),
	},
	Lift = {
		Front = Vector(0, 0, 50), -- Go up when flying forward
		Right = Vector(0, 0, 0),
		Top = Vector(0, 0, -0.5),
	},
	Rail = Vector(1, 5, 30),
	AngleDrag = Vector(0.01, 0.01, 0.01),
}

ENT.Agility = {
	Thrust = 5.7
}

function ENT:maintenance()
	local tb = self:GetTable()
	if tb.disabled then return end

	local repaired = false

	if IsValid(tb.rotor) and tb.rotor.health < 100 then
		tb.rotor.health = tb.rotor.health + 0.1
		repaired = true
	end

	if !IsValid(tb.rotor) then
		self:addRotors(tb)
		self:StopAllSounds(tb)
		repaired = true
	end

	if repaired then
		self:EmitSound("wac/repair_loop.wav", 100, 100)
	end
end

function ENT:addRotors(tb)
	tb = tb or self:GetTable()
	local rotor = ents.Create("prop_physics")
	rotor:SetModel("models/props_junk/sawblade001a.mdl")
	rotor:SetPos(self:LocalToWorld(tb.rotorPos))
	rotor:SetAngles(self:GetAngles() + Angle(90, 0, 0))
	rotor:SetOwner(self:GetOwner())
	rotor:Spawn()
	rotor:SetNotSolid(true)
	rotor.phys = rotor:GetPhysicsObject()
	rotor.phys:EnableGravity(false)
	rotor.phys:SetMass(5)
	--self.rotor.phys:EnableDrag(false)
	rotor:SetNoDraw(true)
	rotor.health = 100
	rotor.wac_ignore = true
	tb.rotor = rotor
	if tb.RotorModel then
		local e = ents.Create("wac_hitdetector")
		e:SetModel(tb.RotorModel)
		e:SetPos(self:LocalToWorld(tb.rotorPos))
		e:SetAngles(self:GetAngles())
		
		e.TouchFunc = function(e)
			local ph = e:GetPhysicsObject()
			if ph:IsValid() then
				local pass=true
				for k,p in pairs(tb.passengers) do
					if p==e then pass=false end
				end
				for _, ent in pairs(tb.entities) do
					if ent == e then pass = false end
				end
				if pass and e != self and !string.find(e:GetClass(), "func*") and IsValid(tb.rotor) and e:GetMoveType() != MOVETYPE_NOCLIP then
					local rotorVel = tb.rotor:GetPhysicsObject():GetAngleVelocity():Length()
					local dmg=(rotorVel*rotorVel + ph:GetVelocity():Length()*ph:GetVelocity():Length())/100000
					ph:AddVelocity((e:GetPos()-tb.rotor:GetPos())*dmg/e:GetPhysicsObject():GetMass()*10)
					self:DamageBigRotor(dmg)
					e:TakeDamage(dmg, IsValid(tb.passengers[1]) and tb.passengers[1] or self, self)
				end
			end
		end
		
		e:Spawn()
		e:SetOwner(self:GetOwner())
		e:SetParent(tb.rotor)
		e.wac_ignore = true
		local obb=e:OBBMaxs()
		tb.RotorWidth=(obb.x>obb.y and obb.x or obb.y)
		tb.RotorHeight=obb.z
		tb.rotorModel=e
		self:AddOnRemove(e)
	end
	constraint.Axis(self, tb.rotor, 0, 0, tb.rotorPos, Vector(0,0,1), 0,0,0.01,1)
	self:AddOnRemove(tb.rotor)
end

function ENT:PhysicsUpdate(ph, tb)
	tb = tb or self:GetTable()
	if tb.Lastphys == CurTime() then return end
	local vel = ph:GetVelocity()	
	local pos = self:GetPos()
	local ri = self:GetRight()
	local up = self:GetUp()
	local fwd = self:GetForward()
	local ang = self:GetAngles()
	local dvel = vel:Length()
	local lvel = self:WorldToLocal(pos + vel)
	
	local hover = self:calcHover(ph, pos, vel, ang, tb)

	local throttle = tb.controls.throttle / 2 + 0.5

	local phm = FrameTime() * 66 --(wac.aircraft.cvars.doubleTick:GetBool() and 2 or 1)
	
	tb.arcade = (IsValid(tb.passengers[1]) and tb.passengers[1]:GetInfo("wac_cl_air_arcade") or 0)

	if !tb.disabled then
	
		if tb.rotor and tb.rotor.phys and tb.rotor.phys:IsValid() then
			tb.rotorRpm = math.Clamp(tb.rotor.phys:GetAngleVelocity().z/3500*tb.rotorDir,-1,1)
			if tb.active and tb.rotor:WaterLevel() <= 0 then
				tb.engineRpm = math.Clamp(tb.engineRpm+FrameTime(),0,1)
				tb.rotor.phys:AddAngleVelocity(Vector(0,0,tb.engineRpm*30 + throttle*tb.engineRpm*20)*tb.rotorDir*phm)
			else
				tb.engineRpm = math.Clamp(tb.engineRpm-FrameTime()*0.16*wac.aircraft.cvars.startSpeed:GetFloat(), 0, 1)
			end
		end
	end
	
	if tb.rotor and tb.rotor.phys and tb.rotor.phys:IsValid() then
		local brake = (throttle+1)*tb.rotorRpm/900+tb.rotor.phys:GetAngleVelocity().z/100
		tb.rotor.phys:AddAngleVelocity(Vector(0,0,-brake + lvel.x*lvel.x/500000)*tb.rotorDir*phm)
	end

	local aeroVelocity, aeroAng = self:calcAerodynamics(ph, tb)

	local controlAng =
		Vector(
			(tb.controls.roll+hover.r)*lvel.x/400,
			(tb.controls.pitch+hover.p)*lvel.x/400,
			tb.controls.yaw*1.5*math.Clamp(lvel.x/20, 0, 1)
		) * tb.Agility.Rotate * (1+tb.arcade)

	local controlThrottle = fwd * (throttle * tb.rotorRpm + tb.rotorRpm/10) * tb.Agility.Thrust
	
	ph:AddAngleVelocity((aeroAng + controlAng)*phm)
	ph:AddVelocity((aeroVelocity + controlThrottle)*phm)

	for _,e in pairs(tb.wheels) do
		if IsValid(e) and e:GetPhysicsObject():IsValid() then
		local ph=e:GetPhysicsObject()
			local wpos = self:WorldToLocal(e:GetPos())
			
			local xpositive = (wpos.x >= 0 and 1 or -1)
			local ypositive = (wpos.y >= 0 and 1 or -1)

			e:GetPhysicsObject():AddVelocity(
				(self:LocalToWorld(Vector(0, 0,
					(math.abs(wpos.y) ^ (1/3))*ypositive*controlAng.x
					- (math.abs(wpos.x) ^ (1/3))*xpositive*controlAng.y
					+ 7
				)/4)-pos --+ up*ang.r*lpos.y/self.WheelStabilize
				+ aeroVelocity*0.8
				+ controlThrottle*0.8
			)*phm)

			if throttle < 0.5 then
				ph:AddAngleVelocity(ph:GetAngleVelocity()*(throttle-0.5)*phm)
			end
		end
	end
	--[[

	for _, e in pairs(self.wheels) do
		if IsValid(e) then
			local ph = e:GetPhysicsObject()
			if ph:IsValid() then
				if self.controls.throttle < -0.8 then
					ph:AddAngleVelocity(ph:GetAngleVelocity()*-0.5*phm)
				end
			end
		end
	end
	

	for _,e in pairs(self.wheels) do
		if IsValid(e) then
			local ph=e:GetPhysicsObject()
			if ph:IsValid() then
				local lpos = self:WorldToLocal(e:GetPos())
				local mass = e:GetPhysicsObject():GetMass()
				e:GetPhysicsObject():AddVelocity(
						Vector(0,0,6)+self:LocalToWorld(Vector(
							0, 0, lpos.x*controlAng.x/mass*10 + lpos.y*controlAng.y/mass*10
						)/4)-pos
				)
				--e:GetPhysicsObject():AddVelocity(up*ang.r*lpos.y/self.WheelStabilize/mass*10)
				if self.controls.throttle < -0.8 then -- apply wheel brake
					ph:AddAngleVelocity(ph:GetAngleVelocity()*-0.5)
				end
			end
		end
	end
	]]
	
	--[[ old
	for _,e in pairs(self.wheels) do
		if IsValid(e) and e:GetPhysicsObject():IsValid() then
		local ph=e:GetPhysicsObject()
			local lpos=self:WorldToLocal(e:GetPos())
			
			e:GetPhysicsObject():AddVelocity((self:LocalToWorld(Vector(0, 0,
					math.abs(lpos.y)*controlAng.x -
					math.abs(lpos.x)*controlAng.y
			)/4)-pos --+ up*ang.r*lpos.y/self.WheelStabilize
			+ aeroVelocity)*phm)

			if throttle < 0.5 then
				ph:AddAngleVelocity(ph:GetAngleVelocity()*(throttle-0.5)*phm)
			end
		end
	end
	]]
	
	tb.Lastphys = CurTime()
end