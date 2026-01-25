game.AddParticles("particles/fire_01.pcf")
PrecacheParticleSystem("fire_small_01")

ITEM.Name = 'Feuer'
ITEM.Price = 80000
ITEM.Material = 'particles/fire_small_01.png'
ITEM.Particle = 'fire_small_01'

function ITEM:OnEquip(ply)
	PS_AttachParticle(ply, self.Particle, PATTACH_ABSORIGIN_FOLLOW, 0, 1)
end

function ITEM:OnHolster(ply)
	PS_DetachParticle(ply)
end