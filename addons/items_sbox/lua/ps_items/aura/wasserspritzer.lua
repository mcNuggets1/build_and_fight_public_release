game.AddParticles("particles/water_impact.pcf")
PrecacheParticleSystem("water_splash_02_droplets")

ITEM.Name = 'Wasserspritzer'
ITEM.Price = 35000
ITEM.Material = 'particles/water_splash_02_droplets.png'
ITEM.Particle = 'water_splash_02_droplets'

function ITEM:OnEquip(ply)
	PS_AttachParticle(ply, self.Particle, PATTACH_ABSORIGIN_FOLLOW, 0, 1)
end

function ITEM:OnHolster(ply)
	PS_DetachParticle(ply)
end