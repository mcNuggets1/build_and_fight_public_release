game.AddParticles("particles/water_impact.pcf")
PrecacheParticleSystem("water_trail_medium_b")

ITEM.Name = 'Wasserspuren'
ITEM.Price = 25000
ITEM.Material = 'particles/water_trail_medium_b.png'
ITEM.Particle = 'water_trail_medium_b'

function ITEM:OnEquip(ply)
	PS_AttachParticle(ply, self.Particle, PATTACH_ABSORIGIN_FOLLOW, 0, 1)
end

function ITEM:OnHolster(ply)
	PS_DetachParticle(ply)
end