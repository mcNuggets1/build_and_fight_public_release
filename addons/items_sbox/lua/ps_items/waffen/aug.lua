ITEM.Name = 'Steyr AUG'
ITEM.Price = 33000
ITEM.Model = 'models/weapons/3_rif_aug.mdl'
ITEM.WeaponClass = 'm9k_aug'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end