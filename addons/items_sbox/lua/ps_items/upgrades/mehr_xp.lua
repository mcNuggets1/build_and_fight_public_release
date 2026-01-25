ITEM.Name = '10% mehr Erfahrung'
ITEM.Price = 40000
ITEM.Model = 'models/props_junk/garbage_glassbottle002a.mdl'
ITEM.NoPreview = true

function ITEM:OnEquip(ply, modifications)
end

function ITEM:OnHolster(ply)
end

if SERVER then
	hook.Add("Perks_AddAdditionalXP", "PS_XPMultiplier", function(ply, n)
		if ply:PS_HasItemEquipped("mehr_exp") then
			return math.ceil(n * 1.1)
		end
	end)
end