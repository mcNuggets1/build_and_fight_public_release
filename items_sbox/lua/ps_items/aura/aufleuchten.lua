game.AddParticles("particles/fire_01.pcf")
PrecacheParticleSystem("fire_medium_01_glow")

ITEM.Name = 'Rotes Aufleuchten'
ITEM.Price = 40000
ITEM.Material = 'particles/fire_medium_01_glow.png'
ITEM.Particle = 'fire_medium_01_glow'

function ITEM:OnEquip(ply)
	PS_AttachParticle(ply, self.Particle, PATTACH_POINT_FOLLOW, ply:LookupAttachment("eyes"), 1)
end

function ITEM:OnHolster(ply)
	PS_DetachParticle(ply)
end