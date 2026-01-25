ITEM.Name = 'SG552'
ITEM.Price = 28000
ITEM.Model = 'models/weapons/3_rif_sg552.mdl'
ITEM.WeaponClass = 'm9k_sg552'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end