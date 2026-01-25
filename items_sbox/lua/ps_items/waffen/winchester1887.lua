ITEM.Name = 'Winchester 1887'
ITEM.Price = 48000
ITEM.Model = 'models/weapons/w_winchester_1887.mdl'
ITEM.WeaponClass = 'm9k_1887winchester'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end