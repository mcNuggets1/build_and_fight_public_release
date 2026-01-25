ITEM.Name = 'FN FAL'
ITEM.Price = 30000
ITEM.Model = 'models/weapons/w_fn_fal.mdl'
ITEM.WeaponClass = 'm9k_fal'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end