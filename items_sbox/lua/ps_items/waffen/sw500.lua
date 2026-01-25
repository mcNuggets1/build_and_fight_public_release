ITEM.Name = 'S&W Model 500'
ITEM.Price = 16000
ITEM.Model = 'models/weapons/w_sw_model_500.mdl'
ITEM.WeaponClass = 'm9k_model500'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end