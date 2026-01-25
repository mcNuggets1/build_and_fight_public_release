ITEM.Name = 'FN P90'
ITEM.Price = 30000
ITEM.Model = 'models/weapons/w_fn_p90.mdl'
ITEM.WeaponClass = 'm9k_smgp90'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end