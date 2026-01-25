ITEM.Name = 'Colt Python'
ITEM.Price = 11000
ITEM.Model = 'models/weapons/w_colt_python.mdl'
ITEM.WeaponClass = 'm9k_coltpython'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end