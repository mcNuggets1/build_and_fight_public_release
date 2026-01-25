ITEM.Name = 'M24'
ITEM.Price = 36000
ITEM.Model = 'models/weapons/w_snip_m24_6.mdl'
ITEM.WeaponClass = 'm9k_m24'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end