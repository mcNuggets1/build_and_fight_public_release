ITEM.Name = 'Raging Bull (Visier)'
ITEM.Price = 13000
ITEM.Model = 'models/weapons/w_taurus_raging_bull.mdl'
ITEM.WeaponClass = 'm9k_scoped_taurus'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end