ITEM.Name = 'F2000'
ITEM.Price = 33000
ITEM.Model = 'models/weapons/w_fn_f2000.mdl'
ITEM.WeaponClass = 'm9k_f2000'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end