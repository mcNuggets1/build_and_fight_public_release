ITEM.Name = 'P08 Luger'
ITEM.Price = 9000
ITEM.Model = 'models/weapons/w_luger_p08.mdl'
ITEM.WeaponClass = 'm9k_luger'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end