ITEM.Name = 'Galil'
ITEM.Price = 27000
ITEM.Model = 'models/weapons/3_rif_galil.mdl'
ITEM.WeaponClass = 'm9k_galil'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end