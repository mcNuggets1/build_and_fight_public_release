game.AddParticles("particles/fire_01.pcf")
PrecacheParticleSystem("embers_small_01")

ITEM.Name = 'Glut'
ITEM.Price = 75000
ITEM.Material = 'particles/embers_small_01.png'
ITEM.Particle = 'embers_small_01'

function ITEM:OnEquip(ply)
	PS_AttachParticle(ply, self.Particle, PATTACH_ABSORIGIN_FOLLOW, 0, 1)
end

function ITEM:OnHolster(ply)
	PS_DetachParticle(ply)
end