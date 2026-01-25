game.AddParticles("particles/blood_impact.pcf")
PrecacheParticleSystem("blood_antlionguard_injured_light")

ITEM.Name = 'Verschleimt'
ITEM.Price = 140000
ITEM.Material = 'particles/blood_antlionguard_injured_light.png'
ITEM.Particle = 'blood_antlionguard_injured_light'

function ITEM:OnEquip(ply)
	PS_AttachParticle(ply, self.Particle, PATTACH_ABSORIGIN_FOLLOW, 0, 2)
end

function ITEM:OnHolster(ply)
	PS_DetachParticle(ply)
end