ITEM.Name = 'PKM'
ITEM.Price = 80000
ITEM.Model = 'models/weapons/w_mach_russ_pkm.mdl'
ITEM.WeaponClass = 'm9k_pkm'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end