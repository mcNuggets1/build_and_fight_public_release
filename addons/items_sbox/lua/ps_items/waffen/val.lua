ITEM.Name = 'AS VAL'
ITEM.Price = 27000
ITEM.Model = 'models/weapons/w_dmg_vally.mdl'
ITEM.WeaponClass = 'm9k_val'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end