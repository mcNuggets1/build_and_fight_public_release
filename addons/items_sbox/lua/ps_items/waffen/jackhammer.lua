ITEM.Name = 'Pancor Jackhammer'
ITEM.Price = 70000
ITEM.Model = 'models/weapons/w_pancor_jackhammer.mdl'
ITEM.WeaponClass = 'm9k_jackhammer'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end