include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("wac/aircraft.lua")

util.AddNetworkString("wac.aircraft.updateWeapons")

ENT.IgnoreDamage = true
ENT.wac_ignore = true

ENT.UsePhysRotor = true
ENT.Submersible = false
ENT.CrRotorWash = true
ENT.RotorWidth = 200

ENT.TopRotor = {
	dir = 1,
	pos = Vector(0, 0, 50),
	angles = Angle(0, 0, 0),
	model = "models/props_borealis/borealis_door001a.mdl",
	health = 100
}

ENT.BackRotor = {
	dir = 1,
	pos = Vector(-185,-3,13),
	angles = Angle(0, 0, 0),
	model = "models/props_borealis/borealis_door001a.mdl",
	health = 40
}

ENT.MaxEngineHealth = 1000 -- FALLBACK

ENT.EngineForce	= 20
ENT.BrakeMul = 1
ENT.AngBrakeMul	= 0.01
ENT.Weight = 1000
ENT.SeatSwitcherPos = Vector(0,0,50)
ENT.BullsEyePos	= Vector(20,0,50)
ENT.MaxEnterDistance = 50
ENT.WheelStabilize = -400
ENT.HatingNPCs = {
	"npc_strider",
	"npc_combinegunship",
	"npc_combinedropship",
	"npc_helicopter",
	"npc_hunter",
	"npc_ministrider",
	"npc_turret_ceiling",
	"npc_turret_floor",
	"npc_turret_ground",
	"npc_rollermine",
	"npc_sniper",
}

--[[
	Defines how the aircraft handles depending on where wind is coming from.
	Rotation defines how it rotates,
	Lift how it rises, sinks or gets pushed right/left,
	Rail defines how stable it is on its path, the higher the less it drifts when turning
]]
ENT.Aerodynamics = {
	Rotation = {
		Front = Vector(0, 0.5, 0),
		Right = Vector(0, 0, 30), -- Rotate towards flying direction
		Top = Vector(0, -5, 0)
	},
	Lift = {
		Front = Vector(0, 0, 3), -- Go up when flying forward
		Right = Vector(0, 0, 0),
		Top = Vector(0, 0, -0.5)
	},
	Rail = Vector(0.3, 3, 2),
	RailRotor = 1, -- like Z rail but only active when moving and the rotor is turning
	AngleDrag = Vector(0.01, 0.01, 0.01),
}


ENT.Agility = {
	Rotate = Vector(1, 1, 1),
	Thrust = 1
}


ENT.Weapons = {}

function ENT:Initialize()
	wac.aircraft.initialize()
	local tb = self:GetTable()
	self:SetModel(tb.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(tb.Weight)
		phys:Wake()
	end
	tb.phys = phys

	tb.engineHealth = MG_Vehicles.Config:GetVehicleHP(self:GetClass()) or tb.MaxEngineHealth
	
	tb.entities = {}
	
	tb.OnRemoveEntities={}
	tb.OnRemoveFunctions={}
	tb.wheels = {}
	
	tb.nextUpdate = 0
	tb.LastDamageTaken=0
	tb.wac_seatswitch = true
	tb.rotorRpm = 0
	
	self:SetNWFloat("health", tb.engineHealth)

	tb.LastActivated = 0
	tb.NextWepSwitch = 0
	tb.NextCamSwitch = 0
	tb.engineRpm = 0
	tb.LastPhys = 0
	tb.passengers = {}
	
	tb.controls = {
		throttle = -1,
		pitch = 0,
		yaw = 0,
		roll = 0,
	}

	self:addRotors(tb)
	self:addSounds()
	self:addWheels(tb)
	self:addWeapons(tb)
	self:addSeats(tb)
	self:addStuff()
	self:addNpcTargets()

	phys:EnableDrag(false)
	tb.SpawnProtection = CurTime() + 5
end

function ENT:addEntity(name)
	local e = ents.Create(name)
	if not IsValid(e) then return nil end
	table.insert(self.entities, e)
	e.Owner = self.Owner
	e:SetNWString("Owner", "World")
	return e
end


function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end


function ENT:addNpcTargets()
	--[[self.npcTargets = {}
	for x = -1, 1 do
		for y = -1, 1 do
			for z = -1, 1 do
				local traceData = {
					start = self:WorldToLocal(Vector(x,y,z)*self:BoundingRadius()),
					endpos = self:GetPos()
				}
				local tr = util.TraceLine(traceData)
				local e = self:addEntity("npc_bullseye")
				e:SetPos(tr.HitPos + tr.HitNormal * 10)
				e:SetParent(self)
				e:SetKeyValue("health", "10000")
				e:SetKeyValue("spawnflags", "256")
				e:SetNotSolid(true)
				e:Spawn()
				e:Activate()
				for _,s in pairs(self.HatingNPCs) do
					e:Fire("SetRelationShip", s.." D_HT 99")
				end
				table.insert(self.npcTargets, e)
			end
		end
	end]]
	for _,s in pairs(self.HatingNPCs) do
		self:Fire("SetRelationShip", s.." D_HT 99")
	end
end


function ENT:addRotors(tb)
	tb = tb or self:GetTable()
	if tb.UsePhysRotor then
		print((tb.backRotor and tb.backRotor != NULL))
		tb.backRotor = (tb.backRotor and tb.backRotor != NULL) and tb.backRotor or self:addBackRotor(tb)
		tb.topRotor = (tb.backRotor and tb.backRotor != NULL) and tb.topRotor or self:addTopRotor(tb)
		self:SetNWEntity("rotor_rear", tb.backRotor)
		constraint.Axis(self, tb.topRotor, 0, 0, tb.TopRotor.pos, Vector(0,0,1), 0,0,0,1)
		if tb.TwinBladed then
			constraint.Axis(self, tb.backRotor, 0, 0, tb.BackRotor.pos, Vector(0,0,1),0,0,0,1)
		else
			constraint.Axis(self, tb.backRotor, 0, 0, tb.BackRotor.pos, Vector(0, 1, 0), 0,0,0,1)
		end
		self:AddOnRemove(tb.topRotor, tb)
		self:AddOnRemove(tb.backRotor, tb)
	end
end

function ENT:addTopRotor(tb)
	local topRotor = self:addEntity("prop_physics")
	topRotor:SetModel("models/props_junk/sawblade001a.mdl")
	topRotor:SetPos(self:LocalToWorld(tb.TopRotor.pos))
	topRotor:SetAngles(self:LocalToWorldAngles(tb.TopRotor.angles))
	topRotor:SetOwner(self:GetOwner())
	topRotor:SetNotSolid(true)
	topRotor:DrawShadow(false)
	topRotor:Spawn()
	topRotor.Phys = topRotor:GetPhysicsObject()
	topRotor.Phys:EnableGravity(false)
	topRotor.Phys:SetMass(5)
	topRotor.Phys:EnableDrag(false)
	topRotor:SetNoDraw(true)
	topRotor:DrawShadow(false)
	topRotor.fHealth = 100
	topRotor.wac_ignore = true
	tb.topRotor = topRotor
	if tb.TopRotor.model then
		local e = self:addEntity("wac_hitdetector")
		self:SetNWEntity("wac_air_rotor_main", e)
		e:SetModel(tb.TopRotor.model)
		e:SetPos(topRotor:GetPos())
		e:SetAngles(topRotor:GetAngles())
			
		e.TouchFunc = function(touchedEnt, pos)
			local ph = touchedEnt:GetPhysicsObject()
			if ph:IsValid() and tb.phys:IsValid() then
				if 
						not table.HasValue(tb.passengers, touchedEnt)
						and !table.HasValue(tb.entities, touchedEnt)
						and touchedEnt != self
						and !string.find(touchedEnt:GetClass(), "func*")
						and IsValid(tb.topRotor)
						and touchedEnt:GetMoveType() != MOVETYPE_NOCLIP
				then
					local rotorVel = topRotor:GetPhysicsObject():GetAngleVelocity():Length()
					local dmg, mass
					if touchedEnt:GetClass() == "worldspawn" then
						dmg = rotorVel * rotorVel / 100000
						mass = 10000
					else
						dmg = (rotorVel * rotorVel + ph:GetVelocity():Length() * ph:GetVelocity():Length()) / 100000
						mass = touchedEnt:GetPhysicsObject():GetMass()
					end
					ph:AddVelocity((pos-topRotor:GetPos())*dmg/mass)
					if !tb.phys then
						self:PhysicsInit(SOLID_VPHYSICS)
						tb.phys = self:GetPhysicsObject()
					end
					tb.phys:AddVelocity((topRotor:GetPos() - pos)*dmg/mass)
					self:DamageBigRotor(dmg, tb)
					e:TakeDamage(dmg, IsValid(tb.passengers[1]) and tb.passengers[1] or self, self)
				end
			end
		end
		
		e:Spawn()
		e:SetNotSolid(true)
		e:SetParent(topRotor)
		e:DrawShadow(false)
		e.wac_ignore = true
		local obb = e:OBBMaxs()
		tb.RotorWidth = (obb.x>obb.y and obb.x or obb.y)
		tb.RotorHeight = obb.z
		topRotor.vis = e
	end

	return topRotor
end

function ENT:addBackRotor(tb)
	tb = tb or self:GetTable()
	local e = self:addEntity("wac_hitdetector")
	e:SetModel(tb.BackRotor.model)
	e:SetAngles(self:LocalToWorldAngles(tb.BackRotor.angles))
	e:SetPos(self:LocalToWorld(tb.BackRotor.pos))
	e:DrawShadow(false)
	if tb.BackRotor.nocollide then
		e:SetNotSolid(true)
	end
	e.Owner = self:GetOwner()
	e:SetNWFloat("rotorhealth", 100)
	e.wac_ignore = true
	e.TouchFunc = function(touchedEnt, pos) -- not colliding with world
		local ph = touchedEnt:GetPhysicsObject()
		if ph:IsValid() then
			if !table.HasValue(tb.passengers, touchedEnt) and !table.HasValue(tb.entities, touchedEnt) and touchedEnt != self and !string.find(touchedEnt:GetClass(), "func*") and IsValid(tb.topRotor) and IsValid(tb.backRotor) and touchedEnt:GetMoveType() != MOVETYPE_NOCLIP then
				local rotorVel = tb.backRotor:GetPhysicsObject():GetAngleVelocity():Length()
				local dmg, mass;
				if touchedEnt:GetClass() == "worldspawn" then
					dmg = rotorVel*rotorVel/100000
					mass = 10000
				else
					dmg=(rotorVel*rotorVel + ph:GetVelocity():Length()*ph:GetVelocity():Length())/100000
					mass = touchedEnt:GetPhysicsObject():GetMass()
				end
				ph:AddVelocity((pos-tb.backRotor:GetPos())*dmg/mass)
				tb.phys:AddVelocity((tb.backRotor:GetPos() - pos)*dmg/mass)
				self:DamageSmallRotor(dmg, tb)
				touchedEnt:TakeDamage(dmg, IsValid(tb.passengers[1]) and tb.passengers[1] or self, self)
			end
		end
	end
	e.OnTakeDamage = function(e, dmg)
		if !dmg:IsExplosionDamage() then
			dmg:ScaleDamage(0.2)
		end
		tb.LastAttacker = dmg:GetAttacker()
		tb.LastDamageTaken = CurTime()
		self:DamageSmallRotor(dmg:GetDamage(), tb)
		e:TakePhysicsDamage(dmg)
	end
	e.Think = function(self) end
	e:Spawn()
	e.Phys=e:GetPhysicsObject()
	if e.Phys:IsValid() then
		e.Phys:Wake()
		e.Phys:EnableGravity(false)
		e.Phys:EnableDrag(false)
		e.Phys:SetMass(10)
	end
	e.fHealth = 40
	self:SetNWEntity("wac_air_rotor_rear", e)
	return e
end


function ENT:addStuff() end


function ENT:addWeapons(tb)
	tb = tb or self:GetTable()
	tb.weapons = {}
	for i, w in pairs(tb.Weapons) do
		if i != "BaseClass" then
			local pod = ents.Create(w.class)
			pod:SetPos(self:GetPos())
			pod:SetAngles(self:GetAngles())
			pod:SetParent(self)
			for index, value in pairs(w.info) do
				pod[index] = value
			end
			pod.aircraft = self
			pod:Spawn()
			pod:Activate()
			pod:SetNoDraw(true)
			pod.podIndex = i
			tb.weapons[i] = pod
			self:AddOnRemove(pod, tb)
		end
	end

	if tb.Camera then
		local camera = ents.Create("prop_physics")
		camera:SetModel("models/props_junk/popcan01a.mdl")
		camera:SetNoDraw(true)
		camera:SetPos(self:LocalToWorld(tb.Camera.pos))
		camera:SetParent(self)
		camera:Spawn()
		tb.camera = camera
	end
end

local IsValid_ent = FindMetaTable("Entity").IsValid
local col_nothing = Color(0, 0, 0, 0)
local vec_0_0_1 = Vector(0,0,1)
function ENT:addSeats(tb)
	tb = tb or self:GetTable()
	tb.seats = {}
	local e = self:addEntity("wac_seat_connector")
	e:SetPos(self:LocalToWorld(tb.SeatSwitcherPos))
	e:SetNoDraw(true)
	e:Spawn()
	e:Activate()
	e.wac_ignore = true
	e:SetNotSolid(true)
	e:SetParent(self)
	self:SetSwitcher(e)
	for k, v in pairs(tb.Seats) do
		if k != "BaseClass" then
			local ang = self:GetAngles()
			local seat = self:addEntity("prop_vehicle_prisoner_pod")
			seat.activeProfile = 1
			seat:SetModel("models/nova/airboat_seat.mdl") 
			seat:SetPos(self:LocalToWorld(v.pos))
			seat:Spawn()
			seat:Activate()
			seat:SetNWInt("selectedWeapon", 0)
			if v.ang then
				local a = self:GetAngles()
				a.y = a.y-90
				a:RotateAroundAxis(vec_0_0_1, v.ang.y)
				seat:SetAngles(a)
			else
				ang:RotateAroundAxis(self:GetUp(), -90)
				seat:SetAngles(ang)
			end
			seat:SetParent(self)
			seat.wac_ignore = true
			seat:SetNWEntity("wac_aircraft", self)
			seat:SetKeyValue("limitview","0")
			self:SetNWInt("seat_"..k.."_actwep", 1)
			seat:SetColor(col_nothing)
			seat:SetRenderMode(1)
			seat:SetNotSolid(true)

			--[[timer.Simple(1, function() -- Fuck Gmod.
				if !IsValid_ent(seat) then return end
				seat:SetNoDraw(true)
				seat:SetNotSolid(true)
				seat:SetRenderMode(0)
			end)]]
			tb.seats[k] = seat
			e:addVehicle(seat)
		end
	end
end

local vec_null = Vector(0,0,0)
local vec_0_1_0 = Vector(0,1,0)
function ENT:addWheels(tb)
	tb = tb or self:GetTable()
	for _,t in pairs(tb.Wheels) do
		if t.mdl then
			local e=self:addEntity("prop_physics")
			e:SetModel(t.mdl)
			e:SetPos(self:LocalToWorld(t.pos))
			e:SetAngles(self:GetAngles())
			e:DrawShadow(false)
			e:Spawn()
			e:Activate()
			local ph=e:GetPhysicsObject()
			if t.mass then
				ph:SetMass(t.mass)
			end
			ph:EnableDrag(false)
			constraint.Axis(e, self, 0, 0, vec_null, self:WorldToLocal(e:LocalToWorld(vec_0_1_0)), 0, 0, t.friction, 1)
			table.insert(tb.wheels, e)
			self:AddOnRemove(e, tb)
		end
	end
end


function ENT:fireWeapon(bool, i)
	if !self.Seats[i].weapons then return end
	local pod = self.weapons[self.Seats[i].weapons[self.seats[i].activeProfile]]
	if !pod then return end
	pod.shouldFire = bool
	pod:trigger(bool, self.seats[i])
end


function ENT:nextWeapon(i, p)
	if !self.Seats[i].weapons then return end
	local seat = self.seats[i]
	local Seat = self.Seats[i]

	local pod = self.weapons[Seat.weapons[seat.activeProfile]]
	if pod then
		pod:select(false)
		pod.seat = nil
	end

	if seat.activeProfile == #Seat.weapons then
		seat.activeProfile = 0
	else
		seat.activeProfile = seat.activeProfile + 1
	end
	if Seat.weapons[seat.activeProfile] then
		local weapon = self.weapons[Seat.weapons[seat.activeProfile]]
		weapon:select(true)
		weapon.seat = seat
	end
	self:SetNWInt("seat_"..i.."_actwep", seat.activeProfile)
end


function ENT:EjectPassenger(ply,idx,t)
	if !idx then
		for k,p in pairs(self.passengers) do
			if p==ply then idx=k end
		end
		if !idx then
			return
		end
	end
	ply.LastVehicleEntered = CurTime()+0.5
	ply:ExitVehicle()
	ply:SetPos(self:LocalToWorld(self.Seats[idx].exit))
	ply:SetVelocity(self:GetPhysicsObject():GetVelocity()*1.2)
	ply:SetEyeAngles((self:LocalToWorld(self.Seats[idx].pos-Vector(0,0,40))-ply:GetPos()):Angle())
	self:updateSeats()
end


function ENT:Use(act, cal)
	if self.disabled then return end
	if act.wac and act.wac.lastEnter and act.wac.lastEnter+0.5 > CurTime() then return end
	local d = self.MaxEnterDistance
	local v
	for k, veh in pairs(self.seats) do
		if veh and veh:IsValid() then
			local psngr = veh:GetPassenger(0)
			if !psngr or !psngr:IsValid() then
				local dist = veh:GetPos():Distance(util.QuickTrace(act:GetShootPos(),act:GetAimVector()*self.MaxEnterDistance,act).HitPos)
				if dist < d then
					d = dist
					v = veh
				end
			end
		end
	end
	act.wac = act.wac or {}
	act.wac.lastEnter = CurTime()
	if v then
		act:EnterVehicle(v)
	end
	self:updateSeats()
end


function ENT:updateSeats(tb)
	tb = tb or self:GetTable()
	if !tb.seats then return end
	for k, veh in pairs(tb.seats) do
		if !veh:IsValid() then return end
		local p = veh:GetPassenger(0)
		if tb.passengers[k] != p then
			if IsValid(self.passengers[k]) then
				tb.passengers[k]:SetNWEntity("wac_aircraft", NULL)
			end
			self:SetNWEntity("passenger_"..k, p)
			tb.passengers[k] = p
			if IsValid(p) then
				p:SetNWInt("wac_passenger_id",k)
				p.wac = p.wac or {}
				p.wac.mouseInput = true
				net.Start("wac.aircraft.updateWeapons")
				net.WriteEntity(self)
				net.WriteInt(table.Count(tb.weapons), 8)
				for name, weapon in pairs(tb.weapons) do
					net.WriteString(name)
					net.WriteEntity(weapon)
				end
				net.Send(p)
			end
		end
	end
	if !IsValid(tb.seats[1]:GetDriver()) then
		tb.controls.pitch = 0
		tb.controls.yaw = 0
		tb.controls.roll = 0
	end
	self:GetSwitcher():updateSeats()
end


function ENT:StopAllSounds(tb)
	tb = tb or self:GetTable()
	for k, s in pairs(tb.sounds) do
		s:Stop()
	end
end


function ENT:RocketAlert()
	if self.rotorRpm > 0.1 then
		local b=false
		local rockets = ents.FindByClass("rpg_missile")
		table.Merge(rockets, ents.FindByClass("wac_w_rocket"))
		for _, e in pairs(rockets) do
			if e:GetPos():Distance(self:GetPos()) < 2000 then b = true break end
		end
		if self.sounds.MissileAlert:IsPlaying() then
			if !b then
				self.sounds.MissileAlert:Stop()
			end
		elseif b then
			self.sounds.MissileAlert:Play()
		end
	end
end


function ENT:setVar(name, var)
	if self:GetNWFloat(name) != var then
		self:SetNWFloat(name, var)
	end
end


function ENT:Think()
	local crt = CurTime()
	local tb = self:GetTable()
	if !tb.disabled then
		if tb.nextUpdate<crt then
			local phys = tb.phys
			if phys and phys:IsValid() then
				phys:Wake()
			end

			--[[
			if IsValid(self.camera) then
				local p = self.seats[self.Camera.seat]:GetDriver()
				if IsValid(p) then
					local view = self:WorldToLocalAngles(p:GetAimVector():Angle())
					local ang = Angle(self.Camera.restrictPitch and 0 or view.p, self.Camera.restrictYaw and 0 or view.y, 0)
					if self.Camera.minAng then
						ang.p = (ang.p > self.Camera.minAng.p and ang.p or self.Camera.minAng.p)
						ang.y = (ang.y > self.Camera.minAng.y and ang.y or self.Camera.minAng.y)
					end
					if self.Camera.maxAng then
						ang.p = (ang.p < self.Camera.maxAng.p and ang.p or self.Camera.maxAng.p)
						ang.y = (ang.y < self.Camera.maxAng.y and ang.y or self.Camera.maxAng.y)
					end
					self.camera:SetAngles(self:LocalToWorldAngles(ang))
				end
			end
			]]

			local target = math.floor(math.Clamp(tb.rotorRpm, 0, 0.99)*3)
			if tb.bodyGroup != target then
				tb.bodyGroup = target
				local topRotor = tb.topRotor
				if topRotor and IsValid(topRotor.vis) then
					topRotor.vis:SetBodygroup(1, tb.bodyGroup)
				end
				if IsValid(tb.backRotor) then
					tb.backRotor:SetBodygroup(1, tb.bodyGroup)
				end
			end

			if tb.skin != self:GetSkin() then
				tb.skin = self:GetSkin()
				self:updateSkin(tb.skin)
			end

			if tb.Burning then
				self:DamageEngine(0.1)
			end
			if tb.CrRotorWash then
				if tb.rotorRpm > 0.6 then
					if !tb.RotorWash then
						local RotorWash = ents.Create("env_rotorwash_emitter")
						RotorWash:SetPos(self:GetPos())
						RotorWash:SetParent(self)
						RotorWash:Activate()
						tb.RotorWash = RotorWash
					end
				else
					if tb.RotorWash then
						tb.RotorWash:Remove()
						tb.RotorWash = nil
					end
				end
			end
			self:RocketAlert(tb)
			if tb.Smoke then
				tb.Smoke:SetKeyValue("renderamt", tostring(math.Clamp(tb.rotorRpm*170, 0, 200)))
				tb.Smoke:SetKeyValue("Speed", tostring(50+tb.rotorRpm*50))
				tb.Smoke:SetKeyValue("JetLength", tostring(50+tb.rotorRpm*50))
			end
			self:updateSeats(tb)
			tb.nextUpdate = crt+0.1
		end
		
		self:setVar("rotorRpm", math.Clamp(tb.rotorRpm, 0, 150))
		self:setVar("engineRpm", tb.engineRpm)
		self:setVar("up", tb.controls.throttle)

		if tb.topRotor and tb.topRotor:WaterLevel() > 0 then
			self:DamageEngine(FrameTime())
		end
	end

	self:NextThink(crt)
	return true
end


function ENT:receiveInput(name, value, seat)
	if seat == 1 then
		if name == "Start" and value > 0.5 then
			self:setEngine(!self.active)
		elseif name == "Throttle" then
			self.controls.throttle = value
		elseif name == "Pitch" then
			self.controls.pitch = value
		elseif name == "Yaw" then
			self.controls.yaw = value
		elseif name == "Roll" then
			self.controls.roll = value
		elseif name == "Hover" and value>0.5 then
			self:SetHover(!self:GetHover())
		elseif name == "FreeView" then
			self.passengers[seat].wac.mouseInput = (value < 0.5)
		end
	end
	if name == "Exit" and value > 0.5 and self.passengers[seat].wac.lastEnter < CurTime() - 0.5 then
		self:EjectPassenger(self.passengers[seat])
	elseif name == "Fire" then
		self:fireWeapon(value > 0.5, seat)
	elseif name == "NextWeapon" and value > 0.5 then
		self:nextWeapon(seat, self.passengers[seat])
	end
end


function ENT:getSeat(player)
	local tb = self:GetTable()
	for i, p in pairs(tb.passengers) do
		if p == player then
			return tb.seats[i]
		end
	end
end


function ENT:setEngine(b)
	local tb = self:GetTable()
	if tb.disabled or tb.engineDead then b = false end
	if b then
		if tb.active then return end
		tb.active = true
	elseif tb.active then
		tb.active=false
	end
	self:SetNWBool("active", tb.active)
end


function ENT:calcAerodynamics(ph, tb)
	tb = tb or self:GetTable()
	local dvel = self:GetVelocity():Length()
	local lvel = self:WorldToLocal(self:GetPos() + self:GetVelocity())

	local targetVelocity = (
		- self:LocalToWorld(tb.Aerodynamics.Rail * lvel * dvel * dvel / 1000000000) + self:GetPos()
		+ self:LocalToWorld(
			tb.Aerodynamics.Lift.Front * lvel.x * dvel / 10000000 +
			tb.Aerodynamics.Lift.Right * lvel.y * dvel / 10000000 +
			tb.Aerodynamics.Lift.Top * lvel.z * dvel / 10000000
		) - self:GetPos()
	) * (1 + tb.arcade)

	local targetAngVel =
		(
			lvel.x*tb.Aerodynamics.Rotation.Front +
			lvel.y*tb.Aerodynamics.Rotation.Right +
			lvel.z*tb.Aerodynamics.Rotation.Top
		) / 10000 / (1 + tb.arcade)
		- ph:GetAngleVelocity()*tb.Aerodynamics.AngleDrag*(1+tb.arcade*2)

	return targetVelocity, targetAngVel
end


function ENT:calcHover(ph,pos,vel,ang)
	if self:GetHover() then
		local v=self:WorldToLocal(pos+vel)
		local av=ph:GetAngleVelocity()
		if !self.EasyMode then
			return{
				p = math.Clamp(-ang.p*0.6-av.y*0.6-v.x*0.025,-0.65,0.65),
				r = math.Clamp(-ang.r*0.6-av.x*0.6+v.y*0.025,-0.65,0.65),
				t = math.Clamp(-v.z*0.3, -0.65, 0.65)
			}
		else
			return{
				p = math.Clamp(-ang.p*0.3-av.y*0.1-v.x*0.005,-0.1,0.1),
				r = math.Clamp(-ang.r*0.6-av.x*0.8+v.y*0.045,-0.6,0.6),
				t = math.Clamp(-v.z*0.3, -0.65, 0.65)
			}
		end
	else
		return {p=0,r=0,t=0}
	end
end


function ENT:PhysicsUpdate(ph)
	local tb = self:GetTable()
	if tb.LastPhys == CurTime() then return end
	local vel = ph:GetVelocity()	
	local pos = self:GetPos()
	local ri = self:GetRight()
	local up = self:GetUp()
	local fwd = self:GetForward()
	local ang = self:GetAngles()
	local dvel = vel:Length()
	local lvel = self:WorldToLocal(pos+vel)

	local hover = self:calcHover(ph,pos,vel,ang)
	
	local rotateX = (tb.controls.roll*1.5+hover.r)*tb.rotorRpm
	local rotateY = (tb.controls.pitch+hover.p)*tb.rotorRpm
	local rotateZ = tb.controls.yaw*1.5*tb.rotorRpm

	tb.arcade = (
		IsValid(tb.passengers[1])
		and tb.passengers[1]:GetInfo("wac_cl_air_arcade")
		or 0
	)

	--local phm = (wac.aircraft.cvars.doubleTick:GetBool() and 2 or 1)
	local phm = FrameTime() * 66
	if tb.UsePhysRotor then
	    
		if tb.active and !tb.engineDead then
			tb.engineRpm = math.Clamp(tb.engineRpm+FrameTime()*0.1*wac.aircraft.cvars.startSpeed:GetFloat(), 0, 1)
		else
			tb.engineRpm = math.Clamp(tb.engineRpm-FrameTime()*0.16*wac.aircraft.cvars.startSpeed:GetFloat(), 0, 1)
		end

	    
		if tb.topRotor and tb.topRotor.Phys and tb.topRotor.Phys:IsValid() then
			if tb.RotorBlurModel then
				tb.topRotor.vis:SetColor(Color(255,255,255,math.Clamp(1.3-tb.rotorRpm,0.1,1)*255))
			end

			-- top rotor physics
			local rotor = {}
			rotor.phys = tb.topRotor.Phys
			rotor.angVel = rotor.phys:GetAngleVelocity()
			rotor.upvel = tb.topRotor:WorldToLocal(tb.topRotor:GetVelocity()+tb.topRotor:GetPos()).z
			rotor.brake =
				math.Clamp(math.abs(rotor.angVel.z) - 2950, 0, 100)/10 -- RPM cap
				+ math.pow(math.Clamp(1500 - math.abs(rotor.angVel.z), 0, 1500)/900, 3)
				+ math.abs(rotor.angVel.z/10000)
				- (rotor.upvel - tb.rotorRpm)*(tb.controls.throttle - 0.5)/1000

			rotor.targetAngVel =
				Vector(0, 0, math.pow(tb.engineRpm,2)*tb.TopRotor.dir*10)
				- rotor.angVel*rotor.brake/200

			rotor.phys:AddAngleVelocity(rotor.targetAngVel)

			tb.rotorRpm = math.Clamp(rotor.angVel.z/3000 * tb.TopRotor.dir, -1, 1)

			-- body physics
			local mind = (100-tb.topRotor.fHealth)/100
			ph:AddAngleVelocity(VectorRand()*tb.rotorRpm*mind*phm)

			if IsValid(tb.backRotor) and tb.backRotor.Phys:IsValid() then
				--self.backRotor.Phys:AddAngleVelocity(Vector(0,self.rotorRpm*300*self.BackRotor.dir-self.backRotor.Phys:GetAngleVelocity().y/10,0)*phm)
				if tb.TwinBladed then
					tb.backRotor.Phys:AddAngleVelocity(rotor.targetAngVel*phm)
				else
					tb.backRotor.Phys:AddAngleVelocity(Vector(0,tb.rotorRpm*300*tb.BackRotor.dir-tb.backRotor.Phys:GetAngleVelocity().y/10,0)*phm)
				end
			else
				ph:AddAngleVelocity((Vector(0,0,0-tb.rotorRpm*tb.TopRotor.dir/2))*phm)
				ph:AddAngleVelocity(VectorRand()*tb.rotorRpm*mind*phm)
				if !tb.sounds.CrashAlarm:IsPlaying() and !tb.disabled then
					tb.sounds.CrashAlarm:Play()
				end
			end

			local throttle = tb.Agility.Thrust*up*((tb.controls.throttle+hover.t)*tb.rotorRpm*1.7*tb.EngineForce/15+tb.rotorRpm*9.15)
			local brakez = self:LocalToWorld(Vector(0, 0, lvel.z*dvel*tb.rotorRpm/100000*tb.Aerodynamics.RailRotor)) - pos
			ph:AddVelocity((throttle - brakez)*phm)
			
		elseif IsValid(tb.backRotor) and tb.backRotor.Phys:IsValid() then
			local backSpeed = (tb.backRotor.Phys:GetAngleVelocity() - ph:GetAngleVelocity()).y
			ph:AddAngleVelocity(Vector(0,0,backSpeed/300))
			tb.backRotor.Phys:AddAngleVelocity(tb.backRotor.Phys:GetAngleVelocity()*-0.01)
		end
	else
		tb.rotorRpm=math.Approach(tb.rotorRpm, tb.active and 1 or 0, tb.EngineForce/1000)
		ph:SetVelocity(vel*0.999+(up*tb.rotorRpm*(tb.controls.throttle+1)*7 + (fwd*math.Clamp(ang.p*0.1, -2, 2) + ri*math.Clamp(ang.r*0.1, -2, 2))*tb.rotorRpm)*phm)
	end

	local controlAng =
			Vector(rotateX, rotateY, IsValid(tb.backRotor) and rotateZ or 0)
			* tb.Agility.Rotate * (1+tb.arcade)

	local aeroVelocity, aeroAng = self:calcAerodynamics(ph, tb)

	ph:AddAngleVelocity((aeroAng + controlAng)*phm)
	ph:AddVelocity(aeroVelocity*phm)

	for _,e in pairs(tb.wheels) do
		if IsValid(e) then
			local ph=e:GetPhysicsObject()
			if ph:IsValid() then
				local lpos=self:WorldToLocal(e:GetPos())
				e:GetPhysicsObject():AddVelocity((
						Vector(0,0,6)+self:LocalToWorld(Vector(
							0, 0, lpos.y*rotateX*tb.Agility.Rotate.x - lpos.x*rotateY*tb.Agility.Rotate.y
						)/10)-pos
				)*phm)
				e:GetPhysicsObject():AddVelocity(up*ang.r*lpos.y/tb.WheelStabilize*phm)
				if tb.controls.throttle < -0.8 then -- apply wheel brake
					ph:AddAngleVelocity(ph:GetAngleVelocity()*-0.5*phm)
				end
			end
		end
	end
	
	tb.LastPhys = CurTime()
end


--[###########]
--[###] DAMAGE
--[###########]

function ENT:fullrepair() -- used for repairman_npc
	local tb = self:GetTable()
	if tb.disabled then return end
	local repaired = false
	local rearmed = false
	
	if IsValid(tb.backRotor) and tb.backRotor.fHealth < tb.backRotor.health then
		tb.backRotor.fHealth = tb.backRotor.health
		repaired = true
	end
	if IsValid(tb.topRotor) and tb.topRotor.fHealth < tb.topRotor.health then
		tb.topRotor.fHealth = tb.topRotor.health
		repaired = true
	end
	if tb.engineHealth < tb.MaxEngineHealth then
		tb.engineHealth = tb.MaxEngineHealth
		repaired = true
	end
	if !IsValid(tb.topRotor) or !IsValid(tb.backRotor) then
		self:addRotors(tb)
		self:StopAllSounds(tb)
		repaired = true
	end
	if tb.weapons then
		for _, w in pairs(tb.weapons) do
			if w:GetAmmo() < w.Ammo then
				w:SetAmmo(w.Ammo)
				rearmed = true
			end
		end
    end
    if rearmed then
        self:EmitSound("items/ammo_pickup.wav", 100, 100)
    end
    if repaired then
        self:EmitSound("wac/repair_loop.wav", 100, 100)
    end
end

-- wac_aircraft_maintenance within 500 units calls this every second
function ENT:maintenance()
	local tb = self:GetTable()
    if tb.disabled then return end
	local repaired = false
	local rearmed = false
	local weaponTries = weaponTries or 0
	local threshold = 200
	
	if IsValid(tb.backRotor) and tb.backRotor.fHealth < tb.BackRotor.health then
		tb.backRotor.fHealth = math.Approach(tb.backRotor.fHealth, tb.BackRotor.health, 100)
		repaired = true
	end
	if IsValid(tb.topRotor) and tb.topRotor.fHealth < tb.BackRotor.health then
		tb.topRotor.fHealth = math.Approach(tb.topRotor.fHealth, tb.TopRotor.health, 120)
		repaired = true
	end
	if tb.engineHealth < tb.MaxEngineHealth then
		tb.engineHealth = math.Approach(tb.engineHealth, tb.MaxEngineHealth, 200)
		repaired = true
	end
	if !IsValid(tb.topRotor) or !IsValid(tb.backRotor) then
		self:addRotors(tb)
		self:StopAllSounds(tb)
		repaired = true
	end
	if tb.weapons then
		for _, w in pairs(tb.weapons) do
			if w:GetAmmo() < w.Ammo then
				w:SetAmmo(math.Approach(w:GetAmmo(), w.Ammo, w.FireRate / 60))
				weaponTries = weaponTries + 1
				if weaponTries >= threshold then
					w:SetAmmo(w.Ammo)
				end
				rearmed = true
			end
		end
    end
    if rearmed then
        self:EmitSound("items/ammo_pickup.wav", 100, 100)
    end
    if repaired then
        self:EmitSound("wac/repair_loop.wav", 100, 100)
    end
end


function ENT:PhysicsCollide(cdat, phys)
	local tb = self:GetTable()
	if wac.aircraft.cvars.nodamage:GetInt() == 1 or CurTime() < (tb.SpawnProtection or 0) then
		return
	end
	if cdat.DeltaTime > 0.5 then
		local mass = cdat.HitObject:GetMass()
		if cdat.HitEntity:GetClass() == "worldspawn" then
			mass = 5000
		end
		local dmg = (cdat.Speed*cdat.Speed*math.Clamp(mass, 0, 5000))/10000000
		if !dmg or dmg < 1 then return end
		self:TakeDamage(dmg*15)
		if dmg > 2 then
			self:EmitSound("vehicles/v8/vehicle_impact_heavy"..math.random(1,4)..".wav")
			local lasta=(tb.LastDamageTaken<CurTime()+6 and tb.LastAttacker or self)
			for k, p in pairs(tb.passengers) do
				if p and p:IsValid() then
					p:TakeDamage(dmg/5, lasta, self)
				end
			end
		end
	end
end

function ENT:DamageSmallRotor(amt, tb)
	tb = tb or self:GetTable()
	if wac.aircraft.cvars.nodamage:GetInt() == 1 or CurTime() < (tb.SpawnProtection or 0) then
		return
	end
	if amt < 1 then return end
	if tb.backRotor and tb.backRotor:IsValid() then
		tb.backRotor:EmitSound("physics/metal/metal_box_impact_bullet"..math.random(1,3)..".wav", math.Clamp(amt*40,20,200))
		tb.backRotor.fHealth = tb.backRotor.fHealth - amt
		tb.backRotor.Phys:AddAngleVelocity(tb.backRotor.Phys:GetAngleVelocity()*-amt/50)
		if tb.backRotor.fHealth < 0 then
			self:KillBackRotor()
			if !tb.sounds.CrashAlarm:IsPlaying() and !tb.disabled then
				tb.sounds.CrashAlarm:Play()
			end
		end
		if tb.backRotor then
			self:SetNWFloat("rotorhealth", tb.backRotor.fHealth)
		else
			self:SetNWFloat("rotorhealth", -1)
		end
		self:DamageEngine(amt/10)
	end
end

function ENT:KillBackRotor(tb)
	tb = tb or self:GetTable()
	if !tb.backRotor then return end
	local e = self:addEntity("prop_physics")
	e:SetAngles(tb.backRotor:GetAngles())
	e:SetPos(tb.backRotor:GetPos())
	e:SetModel(tb.backRotor:GetModel())
	e:SetSkin(tb.backRotor:GetSkin())
	e:DrawShadow(false)
	e:Spawn()
	e:SetVelocity(tb.backRotor:GetVelocity())
	e:GetPhysicsObject():AddAngleVelocity(tb.backRotor.Phys:GetAngleVelocity())
	e:GetPhysicsObject():SetMass(tb.backRotor.Phys:GetMass())
	tb.backRotor:Remove()
	tb.backRotor = nil
	timer.Simple(10, function()
		if e and e:IsValid() then
			e:Remove()
		end
	end)
end

function ENT:DamageBigRotor(amt, tb)
	tb = tb or self:GetTable()
	if wac.aircraft.cvars.nodamage:GetInt() == 1 or CurTime() < (tb.SpawnProtection or 0) then
		return
	end
	if amt < 1 then return end
	self:EmitSound("physics/metal/metal_box_impact_bullet"..math.random(1,3)..".wav", math.Clamp(amt*40,0,100))
	if tb.topRotor and tb.topRotor:IsValid() then
		tb.topRotor.fHealth = tb.topRotor.fHealth - amt
		tb.topRotor.Phys:AddAngleVelocity((tb.topRotor.Phys:GetAngleVelocity()*-amt)*0.001)
		if tb.topRotor.fHealth < 0 then
			self:KillTopRotor(tb)
			if !tb.sounds.CrashAlarm:IsPlaying() and !tb.disabled then
				tb.sounds.CrashAlarm:Play()
			end
		elseif tb.topRotor.fHealth < 50 and !tb.sounds.MinorAlarm:IsPlaying() and !tb.disabled then
			tb.sounds.MinorAlarm:Play()
		end
		if tb.topRotor then
			self:SetNWFloat("rotorhealth", tb.topRotor.fHealth)
		else
			self:SetNWFloat("rotorhealth", -1)
		end
		self:DamageEngine(amt/10)
	end
end

function ENT:KillTopRotor(tb)
	tb = tb or self:GetTable()
	if !tb.topRotor then return end
	self:setEngine(false)
	local e = self:addEntity("prop_physics")
	e:SetPos(tb.topRotor:GetPos())
	e:SetAngles(tb.topRotor:GetAngles())
	e:SetModel(tb.TopRotor.model)
	e:SetSkin(tb.topRotor.vis:GetSkin())
	e:DrawShadow(false)
	e:Spawn()
	self:SetNWFloat("up",0)
	self:SetNWFloat("uptime",0)
	tb.rotorRpm = 0
	local ph = e:GetPhysicsObject()
	e.wac_ignore=true
	if ph:IsValid() then
		ph:SetMass(1000)
		ph:EnableDrag(false)
		ph:AddAngleVelocity(tb.topRotor.Phys:GetAngleVelocity())
		ph:SetVelocity(tb.topRotor.Phys:GetAngleVelocity():Length()*tb.topRotor:GetUp()*0.5 + tb.topRotor:GetVelocity())
	end
	tb.topRotor:Remove()
	tb.topRotor = nil
	e:SetNotSolid(true)
	timer.Simple(15, function()
		if !e or !e:IsValid() then return end
		e:Remove()
	end)
end
--[###] Rotor Damage


function ENT:OnTakeDamage(dmg)
	local tb = self:GetTable()
	if wac.aircraft.cvars.nodamage:GetInt() == 1 or CurTime() < (tb.SpawnProtection or 0) then
		return
	end
	
	if !dmg:IsExplosionDamage() then
		dmg:ScaleDamage(0.19)
	end
	
	local ply = dmg:GetAttacker()
	if !ply then ply = Entity(1) end

	local damage = dmg:GetDamage()
	self:DamageEngine(damage / 3)

	local pos = self:WorldToLocal(dmg:GetDamagePosition())
	if pos:Distance(tb.TopRotor.pos) < 40 then
		self:DamageBigRotor(damage / 15, tb)	
	end
	if pos:Distance(tb.BackRotor.pos) < 70 then
		self:DamageSmallRotor(damage / 2)
	end
	tb.LastAttacker = dmg:GetAttacker()
	tb.LastDamageTaken = CurTime()
	self:TakePhysicsDamage(dmg)
end

function ENT:DamageEngine(amt)
	local tb = self:GetTable()
	if wac.aircraft.cvars.nodamage:GetInt() == 1 or CurTime() < (tb.SpawnProtection or 0) then
		return
	end
	if tb.disabled then return end
	tb.engineHealth = tb.engineHealth - amt

	if tb.engineHealth < (tb.MaxEngineHealth * 0.8)  then
		if !tb.sounds.MinorAlarm:IsPlaying() then
			tb.sounds.MinorAlarm:Play()
		end
		if !tb.Smoke and tb.engineHealth > 0 then
			tb.Smoke = self:CreateSmoke()
		end

		if tb.engineHealth < (tb.MaxEngineHealth * 0.5) then
			if !tb.sounds.LowHealth:IsPlaying() then
				tb.sounds.LowHealth:Play()
			end
			self:setEngine(false)
			tb.engineDead = true

			if tb.engineHealth < (tb.MaxEngineHealth * 0.2) and !tb.EngineFire then
				local fire = ents.Create("env_fire_trail")
				fire:SetPos(self:LocalToWorld(tb.FirePos))
				fire:Spawn()
				fire:SetParent(self)
				tb.Burning = true
				tb.sounds.LowHealth:Play()
				tb.EngineFire = fire
			end

			if tb.engineHealth <= 0 and !tb.disabled then
				tb.disabled = true
				tb.engineRpm = 0
				tb.rotorRpm = 0
				local lasta=(tb.LastDamageTaken<CurTime()+6 and tb.LastAttacker or self)
				for k, p in pairs(tb.passengers) do
					if p and p:IsValid() then
						p:TakeDamage(p:Health() + 20, lasta, self)
					end
				end

				for k,v in pairs(tb.seats) do
					v:Remove()
				end
				tb.passengers={}
				self:StopAllSounds(tb)

				self:setVar("rotorRpm", 0)
				self:setVar("engineRpm", 0)
				self:setVar("up", 0)

				tb.IgnoreDamage = false
				--[[ this affects the base class
					for name, vec in pairs(self.Aerodynamics.Rotation) do
						vec = VectorRand()*100
					end
					for name, vec in pairs(self.Aerodynamics.Lift) do
						vec = VectorRand()
					end
					self.Aerodynamics.Rail = Vector(0.5, 0.5, 0.5)
				]]
				local effectdata = EffectData()
				effectdata:SetStart(self:GetPos())
				effectdata:SetOrigin(self:GetPos())
				effectdata:SetScale(1)
				util.Effect("Explosion", effectdata)
				util.Effect("HelicopterMegaBomb", effectdata)
				util.Effect("cball_explode", effectdata)
				util.BlastDamage(self, self, self:GetPos(), 300, 300)
				self:setEngine(false)
				if tb.Smoke then
					tb.Smoke:Remove()
					tb.Smoke=nil
				end
				if tb.RotorWash then
					tb.RotorWash:Remove()
					tb.RotorWash=nil
				end
				self:SetNWBool("locked", true)
			end
		end
	end
	if tb.Smoke then
		local rcol = math.Clamp(tb.engineHealth * 3.4, 0, 170)
		tb.Smoke:SetKeyValue("rendercolor", rcol.." "..rcol.." "..rcol)
	end
	self:SetNWFloat("health", tb.engineHealth)
end

function ENT:CreateSmoke()
	local smoke = ents.Create("env_smokestack")
	smoke:SetPos(self:LocalToWorld(self.SmokePos))
	smoke:SetAngles(self:GetAngles()+Angle(-90,0,0))
	smoke:SetKeyValue("InitialState", "1")
	smoke:SetKeyValue("WindAngle", "0 0 0")
	smoke:SetKeyValue("WindSpeed", "0")
	smoke:SetKeyValue("rendercolor", "170 170 170")
	smoke:SetKeyValue("renderamt", "170")
	smoke:SetKeyValue("SmokeMaterial", "particle/smokesprites_0001.vmt")
	smoke:SetKeyValue("BaseSpread", "2")
	smoke:SetKeyValue("SpreadSpeed", "2")
	smoke:SetKeyValue("Speed", "50")
	smoke:SetKeyValue("StartSize", "10")
	smoke:SetKeyValue("EndSize", "50")
	smoke:SetKeyValue("roll", "10")
	smoke:SetKeyValue("Rate", "15")
	smoke:SetKeyValue("JetLength", "50")
	smoke:SetKeyValue("twist", "5")
	smoke:Spawn()
	smoke:SetParent(self)
	smoke:Activate()
	return smoke
end

function ENT:AddOnRemove(f, tb)
	tb = tb or self:GetTable()
	if type(f) == "function" then
		table.insert(tb.OnRemoveFunctions, f)	
	elseif type(f) == "Entity" or type(f) == "Vehicle" then
		table.insert(tb.OnRemoveEntities, f)
	end
end

function ENT:OnRemove()
	local tb = self:GetTable()
	self:StopAllSounds(tb)
	for _, p in pairs(tb.passengers) do
		if IsValid(p) then
			p:SetNWInt("wac_passenger_id",0)
		end
	end
	for _, f in pairs(tb.OnRemoveFunctions) do
		f()
	end
	for _, e in pairs(tb.OnRemoveEntities) do
		if IsValid(e) then e:Remove() end
	end
end