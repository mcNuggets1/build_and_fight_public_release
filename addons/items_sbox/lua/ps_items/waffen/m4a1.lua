ITEM.Name = 'M4A1 Iron'
ITEM.Price = 25000
ITEM.Model = 'models/weapons/w_m4a1_iron.mdl'
ITEM.WeaponClass = 'm9k_m4a1'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end