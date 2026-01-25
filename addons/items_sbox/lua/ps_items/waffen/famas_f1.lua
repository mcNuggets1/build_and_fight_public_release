ITEM.Name = 'FAMAS F1'
ITEM.Price = 23000
ITEM.Model = 'models/weapons/w_tct_famas.mdl'
ITEM.WeaponClass = 'm9k_famas'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end