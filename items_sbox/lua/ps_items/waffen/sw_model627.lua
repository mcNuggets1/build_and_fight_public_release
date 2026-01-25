ITEM.Name = 'S&W Model 627'
ITEM.Price = 13000
ITEM.Model = 'models/weapons/w_sw_model_627.mdl'
ITEM.WeaponClass = 'm9k_model627'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end