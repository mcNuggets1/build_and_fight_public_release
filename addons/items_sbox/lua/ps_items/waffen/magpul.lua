ITEM.Name = 'Magpul PDR'
ITEM.Price = 18000
ITEM.Model = 'models/weapons/w_magpul_pdr.mdl'
ITEM.WeaponClass = 'm9k_magpulpdr'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end