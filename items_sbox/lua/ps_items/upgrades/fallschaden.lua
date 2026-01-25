ITEM.Name = '10% reduzierter Fallschaden'
ITEM.Price = 75000
ITEM.Model = 'models/items/hevsuit.mdl'
ITEM.NoPreview = true

function ITEM:OnEquip(ply, modifications)
	if ply:Alive() then
		ply.LowFallDamage = true
	end
end

function ITEM:OnHolster(ply)
	ply.LowFallDamage = nil
end

if SERVER then
	hook.Add("EntityTakeDamage", "PS_ReduceFallDamage", function(ent, dmginfo)
		if ent.LowFallDamage and dmginfo:IsFallDamage() then
			dmginfo:ScaleDamage(0.9)
		end
	end)
end