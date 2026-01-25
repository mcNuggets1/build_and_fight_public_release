ITEM.Name = 'AI AW50'
ITEM.Price = 35000
ITEM.Model = 'models/weapons/w_acc_int_aw50.mdl'
ITEM.WeaponClass = 'm9k_aw50'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end