AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

local effectfiles = file.Find("entities/hoverboard/effects/*.lua", "LUA")
for _, filename in pairs(effectfiles) do
	AddCSLuaFile("effects/"..filename)
end

include("shared.lua")

AccessorFunc(ENT, "pitchspeed", "PitchSpeed", FORCE_NUMBER)
AccessorFunc(ENT, "yawspeed", "YawSpeed", FORCE_NUMBER)
AccessorFunc(ENT, "turnspeed", "TurnSpeed", FORCE_NUMBER)
AccessorFunc(ENT, "rollspeed", "RollSpeed", FORCE_NUMBER)
AccessorFunc(ENT, "jumppower", "JumpPower", FORCE_NUMBER)
AccessorFunc(ENT, "speed", "Speed", FORCE_NUMBER)
AccessorFunc(ENT, "boosterspeed", "BoostMultiplier", FORCE_NUMBER)
AccessorFunc(ENT, "dampingfactor", "DampingFactor", FORCE_NUMBER)
AccessorFunc(ENT, "spring", "Spring", FORCE_NUMBER)

function ENT:Precache()
	self.MountSoundFile = "buttons/button9.wav"
	self.UnMountSoundFile = "buttons/button19.wav"
	self.JumpSoundFile = "weapons/airboat/airboat_gun_energy1.wav"
	util.PrecacheSound(self.MountSoundFile)
	util.PrecacheSound(self.UnMountSoundFile)
	util.PrecacheSound(self.JumpSoundFile)
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:Initialize()
	self:Precache()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(ONOFF_USE)
	self.WaterContacts = 0
	self.Contacts = 0
	self.MouseControl = 1
	self.CanPitch = false
	self:SetBoost(100)
	self.NextBoostThink = 0
	self:SetDampingFactor(2)
	self:SetSpeed(20)
	self:SetYawSpeed(25)
	self:SetTurnSpeed(25)
	self:SetPitchSpeed(25)
	self:SetRollSpeed(20)
	self:SetJumpPower(250)
	self:SetBoostMultiplier(1.5)
	self:SetSpring(0.21)
	self:SetHoverHeight(72)
	self:SetViewDistance(128)
	self:SetBoosting(false)
	self.PlayerMountedTime = 0
	self.PhysgunDisabled = false
	self:CreateAvatar()
	self.Hull = NULL
	local boardphys = self:GetPhysicsObject()
	if IsValid(boardphys) then
		boardphys:SetMass(750)
	end
	self:StartMotionController()
end

function ENT:CreateAvatar()
	self.Avatar = ents.Create("hoverboard_avatar")
	if !IsValid(self.Avatar) then self:Remove() return end
	self.Avatar:SetParent(self)
	self.Avatar:Spawn()
	self.Avatar:SetBoard(self)
	self:SetNW2Entity("Avatar", self.Avatar)
	self:SetAvatarPosition(Vector(0, 0, 3))
end

function ENT:SetAvatarPosition(pos)
	self.Avatar:SetLocalPos(pos)
	self.Avatar:SetLocalAngles(Angle(0, 160 + self:GetBoardRotation(), 0))
end

function ENT:OnRemove()
	self:SetDriver(NULL)
	self:StopMotionController()
end

function ENT:SetControls(num)
	self.MouseControl = num
end

function ENT:SetDriver(pl)
	if !IsValid(self.Avatar) then
		self:CreateAvatar()
	end
	self.Avatar:SetPlayer(pl)
	local driver = self:GetDriver()
	if IsValid(driver) then
		if (!IsValid(pl) or GetConVar("sv_hoverboard_cansteal"):GetBool()) then 
			driver:SetNWEntity("ScriptedVehicle", NULL)
			self:UnMount(driver)
			driver:SetMoveType(driver.OldMoveType)
			driver:DrawWorldModel(true)
			driver:DrawViewModel(true)
			driver:SetNoDraw(false)
			driver:SetCollisionGroup(COLLISION_GROUP_PLAYER)
			self.PhysgunDisabled = false
			self:SetGrinding(false)
			self:SetBoosting(false)
			if (self.OldWeapon and driver:HasWeapon(self.OldWeapon)) then
				driver:SelectWeapon(self.OldWeapon)
			end
		else
			return
		end
	end
	self.PlayerMountedTime = 0
	self.OldWeapon = nil
	if IsValid(pl) then
		if !GetConVar("sv_hoverboard_canshare"):GetBool() then
			if (pl:EntIndex() != self.Creator) then
				return
			end
		end
		self.PlayerMountedTime = CurTime()
		if !IsValid(self.Hull) then
			local boardphys = self:GetPhysicsObject()
			if IsValid(boardphys) then
				self.Hull = ents.Create("hoverboard_hull")
				if !IsValid(self.Hull) then self:Remove() return end
				self.Hull:SetAngles(boardphys:GetAngles())
				local pos = boardphys:GetPos()
				self.Hull:SetPos(pos)
				self.Hull:Spawn()
				self.Hull:SetPlayer(pl)
				self.Hull:SetOwner(self)
				constraint.Weld(self.Hull, self, 0, 0, 0, true, true)
			end
		else
			self.Hull:SetPlayer(pl)
		end
		if IsValid(pl:GetNWEntity("ScriptedVehicle")) then return end
		pl:SetNWEntity("ScriptedVehicle", self)
		local weapon = pl:GetActiveWeapon()
		if IsValid(weapon) then
			self.OldWeapon = weapon:GetClass()
		end
		pl:SelectWeapon("weapon_physcannon")
		pl.OldMoveType = pl:GetMoveType()
		pl:SetMoveType(MOVETYPE_NOCLIP)
		self:Mount(pl)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			local angles = self:GetAngles()
			angles:RotateAroundAxis(angles:Up(), self:GetBoardRotation() + 180)
			local forward = angles:Forward()
			local velocity = forward:DotProduct(pl:GetVelocity()) * forward
			phys:SetVelocity(velocity)
		end
		pl:SetNoDraw(true)
		pl:SetCollisionGroup(COLLISION_GROUP_WORLD)
	else
		SafeRemoveEntity(self.Hull)
	end
	self:SetNW2Entity("Driver", pl)
	self:SetOwner(pl)
end

function ENT:HurtDriver(damage)
	local driver = self:GetDriver()
	if (!IsValid(driver) or self.PlayerMountedTime == 0 or CurTime() - self.PlayerMountedTime < 1) then return end
	driver:TakeDamage(damage, self)
end

function ENT:SetBoost(int)
	self:SetNW2Int("Boost", int)
end

function ENT:SetBoosting(bool)
	self:SetNW2Bool("Boosting", bool)
end

function ENT:IsUpright(physobj)
	local phys = self:GetPhysicsObject()
	if !IsValid(phys) then return end
	local up = phys:GetAngles():Up()
	return (up.z >= 0.33)
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)
end

local function SetPlayerAnimation(ply, anim)
	local board = ply:GetNWEntity("ScriptedVehicle")
	if (!IsValid(board) or board:GetClass() != "hoverboard") then return end
	local seq = "idle_all_angry"
	if board:IsGrinding() then
		seq = "pose_ducking_01"
	end
	seq = ply:LookupSequence(seq)
	ply:SetPlaybackRate(1.)
	ply:ResetSequence(seq)
	ply:SetCycle(0)
	board.Avatar:SetPlaybackRate(1)
	board.Avatar:ResetSequence(seq)
	board.Avatar:SetCycle(0)
	return true
end
hook.Add("SetPlayerAnimation", "Hoverboard_SetPlayerAnimation", SetPlayerAnimation)

function ENT:Think()
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
	local driver = self:GetDriver()
	if IsValid(driver) then
		driver:SetPos(self:GetPos())
		driver:DrawViewModel(false)
		driver:DrawWorldModel(false)
		driver:SetNoDraw(true)
		driver:SetCollisionGroup(COLLISION_GROUP_WORLD)
		if (self:WaterLevel() > 0 or !driver:Alive() or !driver:IsConnected()) then
			self:SetDriver(NULL)
		else
			local weap = driver:GetActiveWeapon()
			if IsValid(weap) then
				weap:SetNextPrimaryFire(CurTime() + 1)
				weap:SetNextSecondaryFire(CurTime() + 1)
			end
		end
		if driver:Alive() and driver:IsConnected() then
			SetPlayerAnimation(driver)
		end
	elseif (self.DriverWeapon != nil) then
		self.DriverWeapon = nil
	end
	if (CurTime() >= self.NextBoostThink) then
		self.NextBoostThink = CurTime() + 0.015
		if self:IsBoosting() then
			self:SetBoost(math.Clamp(self:Boost() - 1, 0, 100))
			if (self:Boost() == 0) then
				self:SetBoosting(false)
			end
		else
			self:SetBoost(math.Clamp(self:Boost() + 1, 0, 100))
		end
	end
	self:NextThink(CurTime())
	return true
end

function ENT:ApplyForwardForce(phys, force, mass)
	local ang = phys:GetAngles()
	ang:RotateAroundAxis(phys:GetAngles():Up(), self:GetBoardRotation())
	ang = ang:Forward()
	return phys:CalculateForceOffset(ang * force * mass,phys:GetPos() + phys:GetAngles():Up() * 0)
end

function ENT:ApplySideForce(phys, force, mass)
	local ang = phys:GetAngles()
	ang:RotateAroundAxis(phys:GetAngles():Up(), self:GetBoardRotation())
	ang = ang:Right()
	return phys:CalculateForceOffset(ang * force * mass,phys:GetPos() + phys:GetAngles():Up() * 0)
end

function ENT:ApplyRotateForce(phys, force, mass)
	local _, force1 = phys:CalculateForceOffset(phys:GetAngles():Right() * force * mass,phys:GetPos() + phys:GetAngles():Forward() * -24 + phys:GetAngles():Up() * 1.36)
	local _, force2 = phys:CalculateForceOffset(phys:GetAngles():Right() * -force * mass,phys:GetPos() + phys:GetAngles():Forward() * 24 + phys:GetAngles():Up() * 1.36)
	return force1 + force2
end

function ENT:ApplyPitchForce(phys, force, mass)
	local ang = phys:GetAngles()
	ang:RotateAroundAxis(phys:GetAngles():Up(), self:GetBoardRotation())
	ang = ang:Forward()
	local _, force1 = phys:CalculateForceOffset(phys:GetAngles():Up() * force * mass, phys:GetPos() + ang * -24 + phys:GetAngles():Up() * 1.36)
	local _, force2 = phys:CalculateForceOffset(phys:GetAngles():Up() * -force * mass, phys:GetPos() + ang * 24 + phys:GetAngles():Up() * 1.36)
	return force1 + force2
end

function ENT:ApplyRollForce(phys, force, mass)
	local ang = phys:GetAngles()
	ang:RotateAroundAxis(phys:GetAngles():Up(), self:GetBoardRotation())
	local _, force1 = phys:CalculateForceOffset(ang:Up() * force * mass,phys:GetPos() + ang:Right() * -24)
	local _, force2 = phys:CalculateForceOffset(ang:Up() * -force * mass,phys:GetPos() + ang:Right() * 24)
	return force1 + force2
end

function ENT:SetGrinding(bool)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		if bool then
			phys:SetMaterial("ice")
		else
			phys:SetMaterial("metal")
		end
	end
	self:SetNW2Bool("Grinding", bool)
end

function ENT:PhysicsCollide(data, physobj)
	local velocity = self:GetVelocity()
	local speed = velocity:LengthSqr()
	if (speed < 22500) then return end
	if (!data.HitEntity or data.HitEntity == NULL or self:WaterLevel() > 0) then return end
	if (data.HitEntity == game.GetWorld() or data.HitEntity:GetSolid() != SOLID_NONE) then
		local edata = EffectData()
 		edata:SetOrigin(data.HitPos)
 		edata:SetNormal(data.HitNormal)
 		edata:SetMagnitude(1.5)
 		edata:SetScale(0.1)
 		edata:SetRadius(12)
		util.Effect("Sparks", edata, true, true)
		self:SetNW2Float("GrindSoundTime", CurTime() + 0.2)
	end
end

function ENT:PhysicsSimulate(phys, deltatime)
	self.Contacts = 0
	self.WaterContacts = 0
	if (self:IsPlayerHolding() or self:WaterLevel() > 0) then
		self.NextUse = CurTime() + 1
		return SIM_NOTHING
	end
	local driver = self:GetDriver()
	local thrusters	= #self.ThrusterPoints
	local thruster_mass	= phys:GetMass() / thrusters
	local hoverheight = math.Clamp(tonumber(self:GetHoverHeight()), 36, 100)
	local massscale	= (phys:GetMass() / 150)
	local angular = Vector(0, 0, 0)
	local linear = Vector(0, 0, 0)
	local spring_power = self:GetSpring()
	local angle_velocity = phys:GetAngleVelocity()
	local velocity = phys:GetVelocity()
	local hover_damping	= Vector(0, 0, (velocity.z * -4.8) / thrusters) * self:GetDampingFactor()
	local angular_damping = angle_velocity * (-6.4 / thrusters) * self:GetDampingFactor()
	local friction = velocity * (-3.6 / thrusters)
	friction.z = 0
	self:SetBoardVelocity(velocity:Length())
	for i = 1, thrusters do
		local point = self:GetThruster(i)
		local tracelen = hoverheight - (self.ThrusterPoints[ i ].Diff or 0)
		local tr = util.TraceLine({
			start = point,
			endpos = point - Vector(0, 0, tracelen),
			filter = { self, driver, self.Hull },
			mask = bit.bor(MASK_SOLID , MASK_WATER),

		})
		if (tr.MatType == MAT_SLOSH) then
			self.WaterContacts = self.WaterContacts + 1
		end
		if (tr.Fraction < 1 and tr.Fraction > 0) then
			self.Contacts = self.Contacts + 1
			local compression = tracelen * (1 - tr.Fraction)
			local force = (spring_power * (self.ThrusterPoints[ i ].Spring or 1)) * compression
			local forcelinear, forceangular = phys:CalculateForceOffset(Vector(0, 0, force * thruster_mass), point)
			angular = angular + forceangular + angular_damping
			linear = linear + forcelinear + hover_damping
		elseif (tr.Fraction == 0) then
			self.Contacts = self.Contacts + 1
		end
	end
	if (self.Contacts > 0 and !self:IsUpright(phys)) then
		return SIM_NOTHING
	elseif self:IsGrinding() then
		self.CanPitch = true
	elseif (self.Contacts >= 1) then
		self.CanPitch = false
	end
	if IsValid(driver) then
		local forward = phys:GetAngles():Forward()
		local right = phys:GetAngles():Right()
		local up = phys:GetAngles():Up()
		forward.z = 0
		right.z = 0
		local forward_speed = self:GetSpeed()
		local rotation_speed = self:GetTurnSpeed()
		local yaw_speed = self:GetYawSpeed()
		local pitch_speed = self:GetPitchSpeed()
		local roll_speed = self:GetRollSpeed()
		local jump_power = self:GetJumpPower()
		driver.IsTurning = false
		if (self.Contacts >= 1) then
			local speed = 0
			if (self.MouseControl == 1) then
				local ang1 = phys:GetAngles()
				local ang2 = driver:GetAngles()
				ang2:RotateAroundAxis(Vector(0, 0, -1), self:GetBoardRotation())
				local diff = (math.NormalizeAngle(ang1.y - ang2.y))
				local delta = (diff > 0) and 1 or -1
				speed = math.Clamp((180 * delta) - diff, -rotation_speed, rotation_speed)
				if ((diff > 0 and diff < 150) or (diff < 0 and diff > -150)) then driver.IsTurning = true end
				if (!driver:KeyDown(IN_FORWARD) and !driver:KeyDown(IN_FORWARD)) then
					if driver:KeyDown(IN_MOVELEFT) then
						local forcel, forcea = self:ApplySideForce(phys, (forward_speed * 0.5), thruster_mass)
						angular = angular + forcea
						linear = linear + forcel + friction
					end
					if driver:KeyDown(IN_MOVERIGHT) then
						local forcel, forcea = self:ApplySideForce(phys, (forward_speed * 0.5) * -1, thruster_mass)
						angular = angular + forcea
						linear = linear + forcel + friction
					end
				end
			else
				if driver:KeyDown(IN_MOVELEFT) then
					speed = rotation_speed
					driver.IsTurning = true
				end
				if driver:KeyDown(IN_MOVERIGHT) then
					speed = -rotation_speed
					driver.IsTurning = true
				end
			end
			local forcelinear, forceangular = phys:CalculateForceOffset(right * speed * thruster_mass, phys:GetPos() + forward * -24 + up * 0)
			angular = angular + forceangular
		else
			driver.IsTurning = true
		end
		if self:IsBoosting() then
			forward_speed = forward_speed * 1.5
		end
		if (driver:KeyDown(IN_FORWARD) and self.Contacts >= 1) then
			local forcel, forcea = self:ApplyForwardForce(phys, -forward_speed, thruster_mass)
			angular = angular + forcea
			linear = linear + forcel + friction
		end
		if (driver:KeyDown(IN_BACK) and self.Contacts >= 1) then
			local forcel, forcea = self:ApplyForwardForce(phys, forward_speed, thruster_mass)
			angular = angular + forcea
			linear = linear + forcel + friction
		end
		if (driver:KeyDown(IN_DUCK) or driver:KeyDown(IN_ATTACK2)) then
			angular = Vector(0, 0, 0)
			linear = Vector(0, 0, 0)
			if !self:IsGrinding() then
				self:SetGrinding(true)
			end
		else
			if self:IsGrinding() then
				self:SetGrinding(false)
			end
		end
		if (self.Contacts == 0 or self:IsGrinding()) then
			if driver:KeyDown(IN_ATTACK) then
				if driver:KeyDown(IN_MOVELEFT) then
					local force = self:ApplyRollForce(phys, roll_speed, thruster_mass)
					angular = angular + force
				end
				if driver:KeyDown(IN_MOVERIGHT) then
					local force = self:ApplyRollForce(phys, -roll_speed, thruster_mass)
					angular = angular + force
				end
			else
				if driver:KeyDown(IN_MOVELEFT) then
					local force = self:ApplyRotateForce(phys, yaw_speed, thruster_mass)
					angular = angular + force
				end
				if driver:KeyDown(IN_MOVERIGHT) then
					local force = self:ApplyRotateForce(phys, -yaw_speed, thruster_mass)
					angular = angular + force
				end
			end
			if (driver:KeyDown(IN_FORWARD) and self.CanPitch) then
				local force = self:ApplyPitchForce(phys, -pitch_speed, thruster_mass)
				angular = angular + force
			end
			if (driver:KeyDown(IN_BACK) and self.CanPitch) then
				local force = self:ApplyPitchForce(phys, pitch_speed, thruster_mass)
				angular = angular + force
			end
		end
		if self.Jumped then
			local speed = velocity:Length()
			speed = speed / 575
			jump_power = math.Clamp(jump_power * speed, 170, 300) / 5
			self.Jumped = false
			self:EmitSound(self.JumpSoundFile)
			for i = 1, thrusters do
				local point = self:GetThruster(i)
				local speed = velocity:Length()
				point = point + (forward * (speed * 0.01))
				local forcelinear, forceangular = phys:CalculateForceOffset(Vector(0, 0, jump_power) * thruster_mass, point)
				angular = angular + forceangular + angular_damping
				linear = linear + forcelinear + friction
			end
		end
	end
	linear = linear + (friction * deltatime * (self:IsGrinding() and 10 or 400) * ((1 / thrusters) * self.Contacts))
	angular = angular + angular_damping * deltatime * 750
	return angular, linear, SIM_GLOBAL_ACCELERATION
end

hook.Add("KeyPress", "Hoverboard_KeyPress", function(ply, in_key)
	local board = ply:GetNWEntity("ScriptedVehicle")
	if (!IsValid(board) or board:GetClass() != "hoverboard") then return end
	if (in_key == IN_USE) then
		board:SetDriver(NULL)
		local phys = board:GetPhysicsObject()
		if IsValid(phys) then
			local ang = board:GetAngles()
			ang.r = 0
			ang:RotateAroundAxis(Vector(0, 0, 1), board:GetBoardRotation() + 180)
			phys:ApplyForceCenter(ang:Forward() * phys:GetMass() * 500)
		end
		board.NextUse = CurTime() + 1
	end
	if (in_key == IN_JUMP and board.Contacts >= 2 and board.WaterContacts < 2) then board.Jumped = true end
	if (in_key == IN_SPEED and !board:IsBoosting() and board:Boost() == 100) then board:SetBoosting(true) end
end)

function ENT:Use(activator, caller)
	if (!IsValid(activator) or !activator:IsPlayer()) then return end
	if (!self:IsUpright() or self:WaterLevel() > 0) then return end
	self.NextUse = self.NextUse or 0
	if (CurTime() < self.NextUse) then return end
	self.NextUse = CurTime() + 1
	self:SetDriver(activator)
end

function ENT:Mount(ply)
	self:EmitSound(self.MountSoundFile)
	local ang = self:GetAngles()
	ang.r = 0
	ang:RotateAroundAxis(Vector(0, 0, 1), 180)
	ang:RotateAroundAxis(Vector(0, 0, 1), self:GetBoardRotation())
	ply:SetAngles(ang)
	ply:SetEyeAngles(ang)
end

function ENT:UnMount(ply)
	self:EmitSound(self.UnMountSoundFile)
	local ang = self:GetAngles()
	ang.r = 0
	ang:RotateAroundAxis(Vector(0, 0, 1), self:GetBoardRotation() + 180)
	ply:SetAngles(ang)
	ply:SetEyeAngles(ang)
	ply:SetMoveType(MOVETYPE_WALK)
	local pos = self:GetPos() + self:GetUp() * 8
	timer.Simple(0, function()
		if !IsValid(ply) then return end
		ply:SetPos(pos)
	end)
end

hook.Add("EntityTakeDamage", "Hoverboard_EntityTakeDamage", function(ent, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if IsValid(attacker) then
		local driver
		local class = attacker:GetClass()
		if (class == "hoverboard") then
			driver = attacker:GetDriver()
		elseif (class == "hoverboard_hull") then
			driver = attacker:GetOwner():GetDriver()
		end
		if IsValid(driver) then
			dmginfo:SetAttacker(driver)
		end
	end
end)

function ENT:AddEffect(effect, pos, normal, scale)
	local index = tonumber(self:GetEffectCount()) or 0
	index = index + 1
	self:SetEffectCount(index)
	self:SetNW2String("Effect"..index, effect)
	self:SetNW2Vector("EffectPos"..index, pos or Vector(0, 0, 0))
	self:SetNW2Vector("EffectNormal"..index, normal or Vector(0, 0, 1))
	self:SetNW2Float("EffectScale"..index, scale or 1)
end