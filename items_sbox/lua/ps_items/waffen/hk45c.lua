ITEM.Name = 'HK45C'
ITEM.Price = 3900
ITEM.Model = 'models/weapons/w_hk45c.mdl'
ITEM.WeaponClass = 'm9k_hk45'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end