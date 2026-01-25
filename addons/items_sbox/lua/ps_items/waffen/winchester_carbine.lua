ITEM.Name = 'Winchester Carbine'
ITEM.Price = 38000
ITEM.Model = 'models/weapons/w_winchester_1873.mdl'
ITEM.WeaponClass = 'm9k_winchester73'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end