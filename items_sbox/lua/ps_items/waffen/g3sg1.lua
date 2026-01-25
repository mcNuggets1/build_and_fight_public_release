ITEM.Name = 'G3SG1'
ITEM.Price = 38000
ITEM.Model = 'models/weapons/3_snip_g3sg1.mdl'
ITEM.WeaponClass = 'm9k_g3sg1'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end