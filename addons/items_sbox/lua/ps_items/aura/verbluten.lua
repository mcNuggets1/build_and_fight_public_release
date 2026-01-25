game.AddParticles("particles/blood_impact.pcf")
PrecacheParticleSystem("blood_antlionguard_injured_heavy_tiny")

ITEM.Name = 'Verbluten'
ITEM.Price = 150000
ITEM.Material = 'particles/blood_antlionguard_injured_heavy_tiny.png'
ITEM.Particle = 'blood_antlionguard_injured_heavy_tiny'

function ITEM:OnEquip(ply)
	PS_AttachParticle(ply, self.Particle, PATTACH_ABSORIGIN_FOLLOW, 0, 2)
end

function ITEM:OnHolster(ply)
	PS_DetachParticle(ply)
end