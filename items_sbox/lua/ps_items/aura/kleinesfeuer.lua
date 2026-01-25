game.AddParticles("particles/fire_01.pcf")
PrecacheParticleSystem("env_fire_tiny")

ITEM.Name = 'Kleines Feuer'
ITEM.Price = 50000
ITEM.Material = 'particles/env_fire_tiny.png'
ITEM.Particle = 'env_fire_tiny'

function ITEM:OnEquip(ply)
	PS_AttachParticle(ply, self.Particle, PATTACH_ABSORIGIN_FOLLOW, 0, 1)
end

function ITEM:OnHolster(ply)
	PS_DetachParticle(ply)
end