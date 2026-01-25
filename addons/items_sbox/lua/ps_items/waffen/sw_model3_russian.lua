ITEM.Name = 'S&W Model 3 Russian'
ITEM.Price = 14000
ITEM.Model = 'models/weapons/w_model_3_rus.mdl'
ITEM.WeaponClass = 'm9k_model3russian'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end