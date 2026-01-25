ENT.Base = "wac_pod_base"
ENT.Type = "anim"

ENT.PrintName = ""
ENT.Author = wac.author
ENT.Category = wac.aircraft.spawnCategory
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.Name = "M197"
ENT.Damage = MG_Vehicles.Config:GetDamage("heli_t1", "M197")
ENT.Ammo = MG_Vehicles.Config:GetAmmo("heli_t1", "M197")
ENT.FireRate = MG_Vehicles.Config:GetFireRate("heli_t1", "M197")
ENT.Spray = 0.3
ENT.FireOffset = Vector(60, 0, 0)

function ENT:SetupDataTables()
	self:base("wac_pod_base").SetupDataTables(self)
	self:NetworkVar("Float", 2, "SpinSpeed")
end