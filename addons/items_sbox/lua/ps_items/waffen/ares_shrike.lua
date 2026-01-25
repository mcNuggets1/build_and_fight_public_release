ITEM.Name = 'Ares Shrike'
ITEM.Price = 50000
ITEM.Model = 'models/weapons/w_ares_shrike.mdl'
ITEM.WeaponClass = 'm9k_ares_shrike'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end