ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.RenderGroup = RENDERGROUP_BOTH

if SERVER then
	util.AddNetworkString("Crates.CrateMessage")
end

if CLIENT then
	net.Receive("Crates.CrateMessage", function()
		local builder = net.ReadBool()
		local removed = net.ReadBool()
		if builder then
			chat.AddText(Color(0, 0, 255), "Eine Builder-Kiste ist " .. (removed and "verschwunden" or "aufgetaucht!\nSchnapp sie dir, bevor sie wieder verschwindet!"))
		else
			chat.AddText(Color(255, 0, 0), "Eine Fighter-Kiste ist " .. (removed and "verschwunden" or "aufgetaucht!\nSchnapp sie dir, bevor sie wieder verschwindet!"))
		end
	end)
end

function ENT:Initialize()
	if SERVER then
		self:SetModel("models/props_junk/wood_crate001a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
		self:SetUseType(SIMPLE_USE)
		self:SetRenderMode(RENDERMODE_TRANSCOLOR)
		self:DrawShadow(false)
		local typ = self.CrateType == "Builder"
		self:SetColor(typ and Color(0, 0, 255) or Color(255, 0, 0))
		net.Start("Crates.CrateMessage")
			net.WriteBool(typ and true or false)
			net.WriteBool(false)
		net.Broadcast()
	else
		local xmin, xmax = self:GetRenderBounds()
		self:SetRenderBounds(xmin + Vector(0, 0, -(Crates.WobbleHeight * 3)), xmax)
		surface.PlaySound("crates/announcing_crate.mp3")
		local edata = EffectData()
		edata:SetStart(self:GetPos())
		edata:SetOrigin(self:GetPos())
		edata:SetEntity(self)
		edata:SetScale(1)
		util.Effect("crate_effect", edata)
		util.Effect("crate_smoke", edata)
	end
	self:SetModelScale(0.65, 0)
	self:SetPos(self:GetPos() + Vector(0, 0, Crates.WobbleHeight * 3))
	self.SpawnPos = self:GetPos()
	self.ExpireTime = CurTime() + Crates.ExpireTime
end

function ENT:Think()
	local curtime = CurTime()
	if SERVER and curtime >= self.ExpireTime then
		net.Start("Crates.CrateMessage")
			net.WriteBool(self.CrateType == "Builder" and true or false)
			net.WriteBool(true)
		net.Broadcast()
		SafeRemoveEntity(self)
		return
	end
	if CLIENT then
		self:SetPos(self.SpawnPos + Vector(0, 0, math.sin(curtime) * Crates.WobbleHeight))
		self:SetAngles(Angle(180, (curtime % 360) * Crates.SpinSpeed, 180))

		local dlight = DynamicLight(self:EntIndex())
		if dlight then
			dlight.Pos = self:GetPos()
			dlight.r = 255
			dlight.g = 255
			dlight.b = 255
			dlight.Brightness = 1
			dlight.Size = 80
			dlight.Decay = 1
			dlight.DieTime = curtime + 0.3
			dlight.Style = 0
		end
	end
	self:NextThink(curtime)
	return true
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end