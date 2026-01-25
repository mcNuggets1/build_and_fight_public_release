ITEM.Name = 'AMD 65'
ITEM.Price = 21000
ITEM.Model = 'models/weapons/w_amd_65.mdl'
ITEM.WeaponClass = 'm9k_amd65'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end