ITEM.Name = 'Striker 12'
ITEM.Price = 65000
ITEM.Model = 'models/weapons/w_striker_12g.mdl'
ITEM.WeaponClass = 'm9k_striker12'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end