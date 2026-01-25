ITEM.Name = 'Scout'
ITEM.Price = 32000
ITEM.Model = 'models/weapons/3_snip_scout.mdl'
ITEM.WeaponClass = 'm9k_scout'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end