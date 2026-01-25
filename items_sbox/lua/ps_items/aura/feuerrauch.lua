game.AddParticles("particles/fire_01.pcf")
PrecacheParticleSystem("smoke_small_01b")

ITEM.Name = 'Feuerrauch'
ITEM.Price = 60000
ITEM.Material = 'particles/smoke_small_01b.png'
ITEM.Particle = 'smoke_small_01b'

function ITEM:OnEquip(ply)
	PS_AttachParticle(ply, self.Particle, PATTACH_POINT_FOLLOW, ply:LookupAttachment("eyes"), 1)
end

function ITEM:OnHolster(ply)
	PS_DetachParticle(ply)
end