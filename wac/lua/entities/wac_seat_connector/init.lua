
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
--include("entities/base_wire_entity.lua")


util.AddNetworkString("wac.seatSwitcher.switch")


function ENT:Initialize()
	self:SetModel("models/props_c17/consolebox01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self.seats = {}
end

function ENT:SpawnFunction(ply, tr)
	if not tr.Hit then return end
	local ent = ents.Create(ClassName)
	ent:SetPos(tr.HitPos+tr.HitNormal*10)
	ent:Spawn()
	ent:Activate()
	ent.Owner = ply	
	return ent
end

function ENT:updateSeats(tb)
	tb = tb or self:GetTable()
	local passengers = {}
	for i = 1, #tb.seats do
		local seat = tb.seats[i]
		if IsValid(seat) then
			local passenger = seat:GetPassenger(0)
			if !passenger or passenger == NULL then continue end
			table.insert(passengers, passenger)
		end
	end
	if #passengers == 0 then return end
	net.Start("wac.seatSwitcher.switch")
	net.WriteEntity(self)
	net.WriteInt(#tb.seats, 8)
	for _, e in pairs(tb.seats) do
		net.WriteEntity(e)
	end
	net.Send(passengers)
end

function ENT:addVehicle(e, tb)
	tb = tb or self:GetTable()
	if table.HasValue(tb.seats, e) then return end
	table.insert(tb.seats, e)
	e.wac_seatswitcher = self
	self:updateSeats(tb)
end

function ENT:removeVehicle(i, tb)
	tb.seats[i].wac_seatswitcher = nil
	table.remove(tb.seats, i)
	self:updateSeats(tb)
end

function ENT:Use(p)
	if IsValid(p) and p:IsPlayer() then
		for _, v in pairs(self.seats) do
			if not IsValid(v:GetPassenger(0)) and not p:InVehicle() then
				p:EnterVehicle(v)
				break
			end
		end
	end
end

function ENT:switchSeat(p, int)
	local tb = self:GetTable()
	if not tb.seats[int] or tb.seats[int]:GetPassenger(0):IsValid() then return end
	local oldang = p:GetAimVector():Angle()
	oldang.y = oldang.y+90
	p:ExitVehicle()
	if VCMod1 then
		p.VC_CanEnterTime = CurTime()
	end
	p:EnterVehicle(tb.seats[int])
	--p:SnapEyeAngles(self.seats[int]:GetAngles())
	self:updateSeats(tb)
end

concommand.Add("wac_setseat", function(p,c,a)
	if not p:InVehicle() then return end
	local veh = p:GetVehicle()
	if veh.wac_seatswitcher then
		veh.wac_seatswitcher:switchSeat(p, tonumber(a[1]))
	end
end)

function ENT:Think()
	local tb = self:GetTable()
	for k,v in pairs(tb.seats) do
		if not IsValid(v) or not v.wac_seatswitcher then
			self:removeVehicle(k, tb)
		end
	end
end

function ENT:BuildDupeInfo()
	local tb = self:GetTable()
	local info=WireLib.BuildDupeInfo(tb.Entity) or {}
	info.v={}
	for k,v in pairs(tb.seats) do
		info.v[k]=v:EntIndex()
	end
	return info
end

function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
	WireLib.ApplyDupeInfo(self, ply, ent, info, GetEntByID)
	local tb = self:GetTable()
	if (info.v) then
		tb.seats={}
		for k,v in pairs(info.v) do
			local e=GetEntByID(v)
			if not e or e ~= GetEntByID(v) then
				e=ents.GetByIndex(v)
			end
			if not table.HasValue(tb.seats,e) then
				self:addVehicle(e, tb)
			end
		end
	end
end