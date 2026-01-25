ITEM.Name = 'Steyr AUG A3'
ITEM.Price = 36000
ITEM.Model = 'models/weapons/w_auga3.mdl'
ITEM.WeaponClass = 'm9k_auga3'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end