ITEM.Name = 'AWP'
ITEM.Price = 50000
ITEM.Model = 'models/weapons/3_snip_awp.mdl'
ITEM.WeaponClass = 'm9k_awp'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end