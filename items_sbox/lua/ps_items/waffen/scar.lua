ITEM.Name = 'SCAR'
ITEM.Price = 22000
ITEM.Model = 'models/weapons/w_fn_scar_h.mdl'
ITEM.WeaponClass = 'm9k_scar'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end