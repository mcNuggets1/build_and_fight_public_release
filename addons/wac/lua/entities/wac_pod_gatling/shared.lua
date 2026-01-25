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

ENT.Name = "M134"
ENT.Ammo = MG_Vehicles.Config:GetAmmo("heli_t1", "M134") or 1
ENT.FireRate = MG_Vehicles.Config:GetFireRate("heli_t1", "M134") or 1
ENT.Sequential = false

ENT.Damage = MG_Vehicles.Config:GetDamage("heli_t1", "M134") or 1
ENT.Force = 10
ENT.Tracer = 0