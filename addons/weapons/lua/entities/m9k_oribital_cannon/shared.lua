ENT.PrintName = "Orbital Strike"
ENT.Type = "anim"
ENT.Targeted = false
ENT.Target = false
	
if SERVER then
	AddCSLuaFile("shared.lua")

	function ENT:Initialize()
		self:SetModel("models/maxofs2d/hover_classic.mdl")
		self:SetMoveType(MOVETYPE_FLY)
		self:DrawShadow(false)
		self:SetRenderMode(RENDERMODE_TRANSALPHA)
		self:SetColor(Color(0,0,0,0))
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
		end
		if self.Targeted then
			self:CannonTargetingPerson(self.Target, self.Sky)
		else
			self:CannonTargeting(self.Ground, self.Sky)
		end
	end

	function ENT:CannonTargeting(ground, sky)
		local targ = ents.Create("info_target")
		if !IsValid(targ) then return end
		targ:SetKeyValue("targetname", tostring(targ))
		targ:SetPos(ground)
		targ:Spawn()
		targ:Fire("Kill", "", 3)
		local laser = ents.Create("env_laser")
		laser:SetKeyValue("texture", "sprites/laserbeam.spr")
		laser:SetKeyValue("TextureScroll", "30")
		laser:SetKeyValue("noiseamplitude", "0")
		laser:SetKeyValue("width", "1")
		laser:SetKeyValue("damage", "0")
		laser:SetKeyValue("rendercolor", "255 0 0")
		laser:SetKeyValue("renderamt", "255")
		laser:SetKeyValue("lasertarget", tostring(targ))
		laser:SetKeyValue("parent", tostring(self))
		laser:SetPos(self:GetPos())
		laser:Spawn()
		laser:Fire("turnon",0)
		laser:Fire("Kill", "", 3)
		laser:SetParent(self)
		timer.Simple(1.5, function()
			if IsValid(self) then
				self:CannonTargeting2(ground, sky)
			end
		end)
	end

	function ENT:CannonTargetingPerson(target, sky)
		if !IsValid(target) then return end
		local targ = ents.Create("info_target")
		if !IsValid(targ) then return end
		targ:SetKeyValue("targetname", tostring(targ))
		targ:SetPos(target:GetPos())
		targ:Spawn()
		targ:Fire("Kill", "", 3)
		targ:SetParent(target)
		local laser = ents.Create("env_laser")
		laser:SetKeyValue("texture", "sprites/laserbeam.spr")
		laser:SetKeyValue("TextureScroll", "30")
		laser:SetKeyValue("noiseamplitude", "0")
		laser:SetKeyValue("width", "1")
		laser:SetKeyValue("damage", "0")
		laser:SetKeyValue("rendercolor", "255 0 0")
		laser:SetKeyValue("renderamt", "255")
		laser:SetKeyValue("lasertarget", tostring(targ))
		laser:SetKeyValue("parent", tostring(self))
		laser:SetPos(self:GetPos())
		laser:Spawn()
		laser:Fire("turnon",0)
		laser:Fire("Kill", "", 3)
		laser:SetParent(self)
		timer.Simple(1.5, function()
			if IsValid(self) then
				self:CannonTargetingPerson2(target, sky)
			end
		end)
	end

	function ENT:CannonTargeting2(ground, sky)
		local targ = ents.Create("info_target")
		if !IsValid(targ) then return end
		targ:SetKeyValue("targetname", tostring(targ))
		targ:SetPos(ground)
		targ:Spawn()
		targ:Fire("Kill", "", 3)
		local laser = ents.Create("env_laser")
		laser:SetKeyValue("texture", "sprites/laserbeam.spr")
		laser:SetKeyValue("TextureScroll", "30")
		laser:SetKeyValue("noiseamplitude", "0")
		laser:SetKeyValue("width", "1")
		laser:SetKeyValue("damage", "0")
		laser:SetKeyValue("rendercolor", "255 0 0")
		laser:SetKeyValue("renderamt", "255")
		laser:SetKeyValue("lasertarget", tostring(targ))
		laser:SetKeyValue("parent", tostring(self))
		laser:SetPos(self:GetPos())
		laser:Spawn()
		laser:Fire("turnon",0)
		laser:Fire("Kill", "", 3)
		laser:SetParent(self)
		timer.Simple(1.5, function()
			if IsValid(self) then
				self:CannonTargeting3(ground, sky)
			end
		end)
	end

	function ENT:CannonTargetingPerson2(target, sky)
		if !IsValid(target) then return end
		local targ = ents.Create("info_target")
		if !IsValid(targ) then return end
		targ:SetKeyValue("targetname", tostring(targ))
		targ:SetPos(target:GetPos())
		targ:Spawn()
		targ:Fire("Kill", "", 3)
		targ:SetParent(target)
		local laser = ents.Create("env_laser")
		laser:SetKeyValue("texture", "sprites/laserbeam.spr")
		laser:SetKeyValue("TextureScroll", "30")
		laser:SetKeyValue("noiseamplitude", "0")
		laser:SetKeyValue("width", "1")
		laser:SetKeyValue("damage", "0")
		laser:SetKeyValue("rendercolor", "255 0 0")
		laser:SetKeyValue("renderamt", "255")
		laser:SetKeyValue("lasertarget", tostring(targ))
		laser:SetKeyValue("parent", tostring(self))
		laser:SetPos(self:GetPos())
		laser:Spawn()
		laser:Fire("turnon",0)
		laser:Fire("Kill", "", 3)
		laser:SetParent(self)
		timer.Simple(1.5, function()
			if IsValid(self) then
				self:CannonTargetingPerson3(target, sky)
			end
		end)
	end

	function ENT:CannonTargeting3(ground, sky)
		local targ = ents.Create("info_target")
		if !IsValid(targ) then return end
		targ:SetKeyValue("targetname", tostring(targ))
		targ:SetPos(ground)
		targ:Spawn()
		targ:Fire("Kill", "", 3)
		local laser = ents.Create("env_laser")
		laser:SetKeyValue("texture", "sprites/laserbeam.spr")
		laser:SetKeyValue("TextureScroll", "30")
		laser:SetKeyValue("noiseamplitude", "0")
		laser:SetKeyValue("width", "1")
		laser:SetKeyValue("damage", "0")
		laser:SetKeyValue("rendercolor", "255 0 0")
		laser:SetKeyValue("renderamt", "255")
		laser:SetKeyValue("lasertarget", tostring(targ))
		laser:SetKeyValue("parent", tostring(self))
		laser:SetPos(self:GetPos())
		laser:Spawn()
		laser:Fire("turnon",0)
		laser:Fire("Kill", "", 3)
		laser:SetParent(self)
		timer.Simple(3, function()
			if IsValid(self) then
				self:GiantLaser(ground, sky)
			end
		end)
	end

	function ENT:CannonTargetingPerson3(target, sky)
		if !IsValid(target) then return end
		local targ = ents.Create("info_target")
		targ:SetKeyValue("targetname", tostring(targ))
		targ:SetPos(target:GetPos())
		targ:Spawn()
		targ:Fire("Kill", "", 3)
		targ:SetParent(target)
		local laser = ents.Create("env_laser")
		laser:SetKeyValue("texture", "sprites/laserbeam.spr")
		laser:SetKeyValue("TextureScroll", "30")
		laser:SetKeyValue("noiseamplitude", "0")
		laser:SetKeyValue("width", "1")
		laser:SetKeyValue("damage", "0")
		laser:SetKeyValue("rendercolor", "255 0 0")
		laser:SetKeyValue("renderamt", "255")
		laser:SetKeyValue("lasertarget", tostring(targ))
		laser:SetKeyValue("parent", tostring(self))
		laser:SetPos(self:GetPos())
		laser:Spawn()
		laser:Fire("turnon",0)
		laser:Fire("Kill", "", 3)
		laser:SetParent(self)
		timer.Simple(3, function()
			if IsValid(self) then
				self:GiantLaserPerson(target, sky)
			end
		end)
	end

	function ENT:GiantLaser(ground, sky)
		local pos = self:GetPos()
		local lowerleft = Vector(870,500,0)
		local lowerright = Vector(-870,500,0)
		local top = Vector(0,-1000,0)
		local targ = ents.Create("info_target")
		if !IsValid(targ) then return end
		targ:SetKeyValue("targetname", tostring(targ))
		targ:SetPos(ground)
		targ:Spawn()
		targ:Fire("Kill", "", 2.25)
		local glow = ents.Create("env_lightglow")
		glow:SetKeyValue("rendercolor", "255 100 100")
		glow:SetKeyValue("VerticalGlowSize", "1800")
		glow:SetKeyValue("HorizontalGlowSize", "1000")
		glow:SetKeyValue("MaxDist", "1000")
		glow:SetKeyValue("MinDist", "4000")
		glow:SetKeyValue("OuterMaxDist", "20000")
		glow:SetPos(ground)
		glow:Spawn()
		glow:Fire("Kill", "", 2.25)
		local laser = ents.Create("env_laser")
		laser:SetKeyValue("texture", "sprites/laser.vmt")
		laser:SetKeyValue("TextureScroll", "30")
		laser:SetKeyValue("noiseamplitude", "0")
		laser:SetKeyValue("width", "500")
		laser:SetKeyValue("damage", "0")
		laser:SetKeyValue("rendercolor", "100 100 255")
		laser:SetKeyValue("renderamt", "255")
		laser:SetKeyValue("lasertarget", tostring(targ))
		laser:SetPos(self:GetPos() + top)
		laser:Spawn()
		laser:Fire("turnon",0)
		laser:Fire("Kill", "", 2.25)
		laser:SetParent(self)
		local smoke = EffectData()
		smoke:SetOrigin(ground)
		smoke:SetEntity(self.Owner)
		smoke:SetScale(2)
		util.Effect("m9k_orbital_smoke", smoke, true, true)
		timer.Simple(0.75, function()
			if !IsValid(self) then return end
			local laser2 = ents.Create("env_laser")
			laser2:SetKeyValue("texture", "sprites/laser.vmt")
			laser2:SetKeyValue("TextureScroll", "30")
			laser2:SetKeyValue("noiseamplitude", "0")
			laser2:SetKeyValue("width", "500")
			laser2:SetKeyValue("damage", "0")
			laser2:SetKeyValue("rendercolor", "100 100 255")
			laser2:SetKeyValue("renderamt", "255")
			laser2:SetKeyValue("lasertarget", tostring(targ))
			laser2:SetPos(self:GetPos() + lowerleft)
			laser2:Spawn()
			laser2:Fire("turnon",0)
			laser2:Fire("Kill", "", 1.5)
			laser2:SetParent(self)
		end)
		timer.Simple(1.25, function()
			if !IsValid(self) then return end
			local laser3 = ents.Create("env_laser")
			laser3:SetKeyValue("texture", "sprites/laser.vmt")
			laser3:SetKeyValue("TextureScroll", "30")
			laser3:SetKeyValue("noiseamplitude", "0")
			laser3:SetKeyValue("width", "500")
			laser3:SetKeyValue("damage", "0")
			laser3:SetKeyValue("rendercolor", "100 100 255")
			laser3:SetKeyValue("renderamt", "255")
			laser3:SetKeyValue("lasertarget", tostring(targ))
			laser3:SetPos(self:GetPos() + lowerright)
			laser3:Spawn()
			laser3:Fire("turnon",0)
			laser3:Fire("Kill", "", 1)
			laser3:SetParent(self)
		end)
		timer.Simple(1.75, function()
			if !IsValid(self) then return end
			local laser4 = ents.Create("env_laser")
			laser4:SetKeyValue("texture", "sprites/laser.vmt")
			laser4:SetKeyValue("TextureScroll", "30")
			laser4:SetKeyValue("noiseamplitude", "0")
			laser4:SetKeyValue("width", "500")
			laser4:SetKeyValue("damage", "0")
			laser4:SetKeyValue("rendercolor", "100 100 255")
			laser4:SetKeyValue("renderamt", "255")
			laser4:SetKeyValue("lasertarget", tostring(targ))
		  	laser4:SetPos(self:GetPos())
			laser4:Spawn()
			laser4:Fire("turnon",0)
			laser4:Fire("Kill", "", 0.5)
			laser4:SetParent(self)
		end)
		timer.Simple(2.25, function()
			if IsValid(self) then
				self:MassiveFuckingExplosion(ground, sky)
			end
		end)
		timer.Simple(1.5, function() 
			for _,v in ipairs(player.GetAll()) do 
				v:EmitSound("npc/strider/fire.wav")
				sound.Play("npc/strider/fire.wav", v:GetPos(), 100, 100, 1)
			end
		end)
	end

	function ENT:GiantLaserPerson(ground, sky)	
		if !IsValid(ground) then return end
		local pos = self:GetPos()
		local lowerleft = Vector(870,500,0)
		local lowerright = Vector(-870,500,0)
		local top = Vector(0,-1000,0)
		local targ = ents.Create("info_target")
		if !IsValid(targ) then return end
		targ:SetKeyValue("targetname", tostring(targ))
		targ:SetPos(ground:GetPos())
		targ:Spawn()
		targ:Fire("Kill", "", 2.25)
		targ:SetParent(ground)
		local targ2 = ents.Create("info_target")
		if !IsValid(targ2) then return end
		targ2:SetKeyValue("targetname", tostring(targ2))
		targ2:SetPos(self:GetPos())
		targ2:Spawn()
		targ2:Fire("Kill", "", 2.25)
		targ2:SetParent(self)
		local laser0 = ents.Create("env_laser")
		laser0:SetKeyValue("texture", "sprites/laser.vmt")
		laser0:SetKeyValue("TextureScroll", "30")
		laser0:SetKeyValue("noiseamplitude", "0")
		laser0:SetKeyValue("width", "500")
		laser0:SetKeyValue("damage", "0")
		laser0:SetKeyValue("rendercolor", "100 100 255")
		laser0:SetKeyValue("renderamt", "255")
		laser0:SetKeyValue("lasertarget", tostring(targ2))
		laser0:SetPos(ground:GetPos() + Vector(0,0,80))
		laser0:Spawn()
		laser0:Fire("turnon",0)
		laser0:Fire("Kill", "", 2.25)
		laser0:SetParent(ground)
		local laser = ents.Create("env_laser")
		laser:SetKeyValue("texture", "sprites/laser.vmt")
		laser:SetKeyValue("TextureScroll", "30")
		laser:SetKeyValue("noiseamplitude", "0")
		laser:SetKeyValue("width", "500")
		laser:SetKeyValue("damage", "0")
		laser:SetKeyValue("rendercolor", "100 100 255")
		laser:SetKeyValue("renderamt", "255")
		laser:SetKeyValue("lasertarget", tostring(targ))
		laser:SetPos(self:GetPos() + top)
		laser:Spawn()
		laser:Fire("turnon",0)
		laser:Fire("Kill", "", 2.25)
		laser:SetParent(self)
		local smoke = EffectData()
		smoke:SetOrigin(ground:GetPos())
		smoke:SetEntity(self.Owner)
		smoke:SetScale(2)
		util.Effect("m9k_orbital_smoke", smoke)
		timer.Simple(0.75, function()
			if !IsValid(self) then return end
			local laser2 = ents.Create("env_laser")
			laser2:SetKeyValue("texture", "sprites/laser.vmt")
			laser2:SetKeyValue("TextureScroll", "30")
			laser2:SetKeyValue("noiseamplitude", "0")
			laser2:SetKeyValue("width", "500")
			laser2:SetKeyValue("damage", "0")
			laser2:SetKeyValue("rendercolor", "100 100 255")
			laser2:SetKeyValue("renderamt", "255")
			laser2:SetKeyValue("lasertarget", tostring(targ))
			laser2:SetPos(self:GetPos() + lowerleft)
			laser2:Spawn()
			laser2:Fire("turnon",0)
			laser2:Fire("Kill", "", 1.5)
			laser2:SetParent(self)
		end)
		timer.Simple(1.25, function()
			if !IsValid(self) then return end
			local laser3 = ents.Create("env_laser")
			laser3:SetKeyValue("texture", "sprites/laser.vmt")
			laser3:SetKeyValue("TextureScroll", "30")
			laser3:SetKeyValue("noiseamplitude", "0")
			laser3:SetKeyValue("width", "500")
			laser3:SetKeyValue("damage", "0")
			laser3:SetKeyValue("rendercolor", "100 100 255")
			laser3:SetKeyValue("renderamt", "255")
			laser3:SetKeyValue("lasertarget", tostring(targ))
			laser3:SetPos(self:GetPos() + lowerright)
			laser3:Spawn()
			laser3:Fire("turnon",0)
			laser3:Fire("Kill", "", 1)
			laser3:SetParent(self)
		end)
		timer.Simple(1.75, function()
			if !IsValid(self) then return end
			local laser4 = ents.Create("env_laser")
			laser4:SetKeyValue("texture", "sprites/laser.vmt")
			laser4:SetKeyValue("TextureScroll", "30")
			laser4:SetKeyValue("noiseamplitude", "0")
		   	laser4:SetKeyValue("width", "500")
		 	laser4:SetKeyValue("damage", "0")
		 	laser4:SetKeyValue("rendercolor", "100 100 255")
		   	laser4:SetKeyValue("renderamt", "255")
			laser4:SetKeyValue("lasertarget", tostring(targ))
			laser4:SetPos(self:GetPos())
			laser4:Spawn()
			laser4:Fire("turnon",0)
			laser4:Fire("Kill", "", 0.5)
			laser4:SetParent(self)
		end)
		timer.Simple(2.25, function()
			if IsValid(self) then
				self:MassiveFuckingExplosionPerson(ground, sky)
			end
		end)
		timer.Simple(1.5, function() 
			for _,v in ipairs(player.GetAll()) do 
				sound.Play("npc/strider/fire.wav", v:GetPos(), 100, 100)
			end
		end)
	end

	function ENT:MassiveFuckingExplosion(ground, sky)
		local pos = self:GetPos()
		local lowerleft = pos + Vector(870,500,0)
		local lowerright = pos +  Vector(-870,500,0)
		local top = pos + Vector(0,-1000,0)
		local tr1 = {}
		tr1.start = lowerleft
		tr1.endpos = ground
		tr1.filter = self
		tr1 = util.TraceLine(tr1)
		local tr2 = {}
		tr2.start = lowerleft
		tr2.endpos = ground
		tr2.filter = self
		tr2 = util.TraceLine(tr2)
		local tr3 = {}
		tr3.start = lowerright
		tr3.endpos = ground
		tr3.filter = self
		tr3 = util.TraceLine(tr3)
		local tr4 = {}
		tr4.start = lowerright
		tr4.endpos = ground
		tr4.filter = self
		tr4 = util.TraceLine(tr4)
		if tr2.HitPos != ground then
			self:SmallerExplo(tr2.HitPos, tr2.Normal)
		end
		if tr3.HitPos != ground then
			self:SmallerExplo(tr3.HitPos, tr3.Normal)
		end
		if tr4.HitPos != ground then
			self:SmallerExplo(tr4.HitPos, tr4.Normal)
		end
		local edata = EffectData()
		edata:SetOrigin(ground)
		edata:SetRadius(5000)
		edata:SetMagnitude(5000)
		util.Effect("HelicopterMegaBomb", edata)
		local edata = EffectData()
		edata:SetOrigin(ground)
		edata:SetStart(ground)
		util.Effect("Explosion", edata, true, true)
		local edata = EffectData()
		edata:SetOrigin(ground)
		edata:SetNormal(Vector(0,0,1))
		edata:SetEntity(self.Owner)
		edata:SetScale(8)
		edata:SetRadius(67)
		edata:SetMagnitude(8)
		util.Effect("m9k_gdcw_cinematicboom", edata)
		util.BlastDamage(self, (self:OwnerCheck()), ground, 4000, 500)
		local shake = ents.Create("env_shake")
		shake:SetOwner(self.Owner)
		shake:SetPos(ground)
		shake:SetKeyValue("amplitude", "4000")
		shake:SetKeyValue("radius", "5000")
		shake:SetKeyValue("duration", "2.5")
		shake:SetKeyValue("frequency", "255")
		shake:SetKeyValue("spawnflags", "4")
		shake:Spawn()
		shake:Activate()
		shake:Fire("StartShake", "", 0)
		self:Remove()
		local smoke = EffectData()
		smoke:SetOrigin(ground)
		smoke:SetEntity(self.Owner)
		smoke:SetScale(2)
		util.Effect("m9k_orbital_smoke", smoke)
		for _,v in ipairs(player.GetAll()) do
			if IsValid(v) then
				v:EmitSound("ambient/explosions/explode_6.wav")
			end
	   end
	end

	function ENT:MassiveFuckingExplosionPerson(ground, sky)
		if !IsValid(ground) then return end
		local pos = self:GetPos()
		local lowerleft = pos + Vector(870,500,0)
		local lowerright = pos +  Vector(-870,500,0)
		local top = pos + Vector(0,-1000,0)
		local tr1 = {}
		tr1.start = lowerleft
		tr1.endpos = ground:GetPos()
		tr1.filter = self, ground
		tr1 = util.TraceLine(tr1)
		local tr2 = {}
		tr2.start = lowerleft
		tr2.endpos = ground:GetPos()
		tr2.filter = self, ground
		tr2 = util.TraceLine(tr2)
		local tr3 = {}
		tr3.start = lowerright
		tr3.endpos = ground:GetPos()
		tr3.filter = self, ground
		tr3 = util.TraceLine(tr3)
		local tr4 = {}
		tr4.start = lowerright
		tr4.endpos = ground:GetPos()
		tr4.filter = self, ground
		tr4 = util.TraceLine(tr4)
		if tr2.Entity != ground then
			self:SmallerExplo(tr2.HitPos, tr2.Normal)
		end
		if tr3.Entity != ground then
			self:SmallerExplo(tr3.HitPos, tr3.Normal)
		end
		if tr4.Entity != ground then
			self:SmallerExplo(tr4.HitPos, tr4.Normal)
		end
		local edata = EffectData()
		edata:SetOrigin(ground:GetPos())
		edata:SetRadius(5000)
		edata:SetMagnitude(5000)
		util.Effect("HelicopterMegaBomb", edata)
		local edata = EffectData()
		edata:SetOrigin(ground:GetPos())
		edata:SetStart(ground:GetPos())
		util.Effect("Explosion", edata, true, true)
		local edata = EffectData()
		edata:SetOrigin(ground:GetPos())
		edata:SetNormal(Vector(0,0,1))
		edata:SetEntity(self.Owner)
		edata:SetScale(8)
		edata:SetRadius(67)
		edata:SetMagnitude(8)
		util.Effect("m9k_gdcw_cinematicboom", edata)
		util.BlastDamage(self, (self:OwnerCheck()), ground:GetPos(), 4000, 500)
	 	local shake = ents.Create("env_shake")
		shake:SetOwner(self.Owner)
		shake:SetPos(ground:GetPos())
		shake:SetKeyValue("amplitude", "4000")
		shake:SetKeyValue("radius", "5000")
		shake:SetKeyValue("duration", "2.5")
		shake:SetKeyValue("frequency", "255")
		shake:SetKeyValue("spawnflags", "4")
		shake:Spawn()
		shake:Activate()
		shake:Fire("StartShake", "", 0)
		self:Remove()
		local smoke = EffectData()
		smoke:SetOrigin(ground:GetPos())
		smoke:SetEntity(self.Owner)
		smoke:SetScale(1)
		util.Effect("m9k_orbital_smoke", smoke)
		for _,v in ipairs(player.GetAll()) do
			sound.Play("ambient/explosions/explode_6.wav", v:GetPos(), 100, 100)
		end
	end

	function ENT:SmallerExplo(targ, norm)
		util.BlastDamage(self, self:OwnerCheck(), targ, 1000, 150)
		local edata = EffectData()
		edata:SetOrigin(targ)
		edata:SetRadius(100)
		edata:SetMagnitude(100)
		util.Effect("HelicopterMegaBomb", edata)
		local edata = EffectData()
		edata:SetOrigin(targ)
		edata:SetStart(targ)
		util.Effect("Explosion", edata, true, true)
	end

	function ENT:OwnerCheck()
		if IsValid(self.Owner) then
			return self.Owner
		else
			return self
		end
	end
end