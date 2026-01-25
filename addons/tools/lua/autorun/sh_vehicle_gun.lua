properties.Add("VehicleGun_Add", {
	MenuLabel = "Bewaffnung hinzufügen",
	Order = 0,
	MenuIcon = "icon16/gun.png",
	Filter = function(self, ent, ply)
		if !IsValid(ent) or !ent:IsVehicle() or ent:GetNW2Bool("VehicleGun_Equipped") then return false end
		if (ent:GetModel() != "models/buggy.mdl" and ent:GetModel() != "models/airboat.mdl") then return false end
		if !gamemode.Call("CanProperty", ply, "vehiclegun_add", ent) then return false end
		return true
	end,
	Action = function(self, ent)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	Receive = function(self, length, ply)
		local ent = net.ReadEntity()
		if IsValid(ply) and IsValid(ent) and ent:IsVehicle() then
			if (ent:GetModel() != "models/buggy.mdl" and ent:GetModel() != "models/airboat.mdl") then return end
			ent:SetNWBool("VehicleGun_Equipped", true)
			ent:Fire("EnableGun", 1, 0)
			ent:SetKeyValue("EnableGun", 1, 0)
			ent:SetBodygroup(1, 1)
		end
	end
})

properties.Add("VehicleGun_Remove", {
	MenuLabel = "Bewaffnung entfernen",
	Order = 0,
	MenuIcon = "icon16/gun.png",
	Filter = function(self, ent, ply)
		if !IsValid(ent) or !ent:IsVehicle() or !ent:GetNW2Bool("VehicleGun_Equipped") then return false end
		if (ent:GetModel() != "models/buggy.mdl" and ent:GetModel() != "models/airboat.mdl") then return false end
		if !gamemode.Call("CanProperty", ply, "vehiclegun_remove", ent) then return false end
		return true
	end,
	Action = function(self, ent)
		self:MsgStart()
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	Receive = function(self, length, ply)
		local ent = net.ReadEntity()
		if IsValid(ply) and IsValid(ent) and ent:IsVehicle() then
			if (ent:GetModel() != "models/buggy.mdl" and ent:GetModel() != "models/airboat.mdl") then return end
			ent:SetNW2Bool("VehicleGun_Equipped", false)
			ent:Fire("EnableGun", 0, 0)
			ent:SetKeyValue("EnableGun", 0, 0)
			ent:SetBodygroup(1, 0)
		end
	end
})