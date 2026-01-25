local Entity = FindMetaTable("Entity")
function Entity:MovePet()
	local ply = self:GetOwner()
	if !IsValid(ply) then SafeRemoveEntity(self) return end
	if ply:GetNoDraw() then
		self:SetNoDraw(true)
	else
		self:SetNoDraw(false)
	end
	local target_pos = self:SetPetPos()
	local pos_to_do = target_pos - self:GetPos()
	local velocity = math.Clamp(pos_to_do:Length(), Pets.MinSpeed, Pets.MaxSpeed)
	pos_to_do:Normalize()
	self:SetLocalVelocity(pos_to_do * velocity * Pets.SpeedMult)
end

function Entity:SetPetAngles(offset)
	local tb = self:GetTable()
	tb.AngleWeight = tb.AngleWeight or 0
	local ply = self:GetOwner()
	local vel = self:GetVelocity()
	local speed = vel:LengthSqr() * 0.0005
	if speed > 1.5 then
		tb.AngleWeight = math.Approach(tb.AngleWeight, 1, FrameTime() * 3)
	else
		tb.AngleWeight = math.Approach(tb.AngleWeight, 0, FrameTime() * 2.5)
	end
	offset = offset or Angle(0, 0, 0)
	local move_angle = Angle(0, vel:Angle().y, 0) + offset
	local stop_angle = Angle(0, ply:GetAngles().y, 0) + offset
	self:SetAngles(LerpAngle(tb.AngleWeight, stop_angle, move_angle))
	return speed, tb.AngleWeight
end

local vector_1 = Vector(0, 0, 1)
function Entity:SetPetPos()
	local ply = self:GetOwner()
	local ply_ang = Angle(0, ply:GetAngles().y, 0)
	local origin = ply:GetPos() + Pets.Origin
	local pos = origin + ply_ang:Right() * Pets.Right + ply_ang:Up() * Pets.Up * (ply:Crouching() and -0.7 or 1) + ply_ang:Forward() * Pets.Forward
	return pos + vector_1 * math.sin(CurTime() * Pets.WobbleSpeed) * Pets.Wobble
end

function Entity:AddRandomPetSound(sound, dist, pitch, volume)
	if !Pets.EnableSounds then return end
	self.PetSounds = self.PetSounds or {}
	local tbl = {}
	tbl.SoundPath = sound
	tbl.dist = dist or 75
	tbl.pitch = pitch or 100
	tbl.volume = volume or 1
	table.insert(self.PetSounds, tbl)
	self:CreatePetSoundTimer(Pets.SoundsMinTime, Pets.SoundsMaxTime)
end

function Entity:CreatePetSoundTimer(min, max)
	if !self.PetSounds then return end
	local fn = function()
		if !IsValid(self) or !self.PetSounds then return end
		if !self:GetNoDraw() then
			local num = math.random(#self.PetSounds)
			local tbl = self.PetSounds[num]
			self:EmitSound(tbl.SoundPath or "", tbl.dist or 75, tbl.pitch or 100, tbl.volume or 1)
		end
		self:CreatePetSoundTimer(min, max)
	end
	timer.Create("Fo_PetSounds_"..self:EntIndex(), math.random(min, max), 1, fn)
end