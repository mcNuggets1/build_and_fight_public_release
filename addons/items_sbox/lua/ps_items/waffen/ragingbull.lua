ITEM.Name = 'Raging Bull'
ITEM.Price = 11000
ITEM.Model = 'models/weapons/w_taurus_raging_bull.mdl'
ITEM.WeaponClass = 'm9k_ragingbull'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end