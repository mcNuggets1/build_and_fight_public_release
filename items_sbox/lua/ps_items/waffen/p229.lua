ITEM.Name = 'SIG Sauer P229 R'
ITEM.Price = 7000
ITEM.Model = 'models/weapons/w_sig_229r.mdl'
ITEM.WeaponClass = 'm9k_sig_p229r'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end