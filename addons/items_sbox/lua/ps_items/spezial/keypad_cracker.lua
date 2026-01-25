ITEM.Name = 'Keypad Cracker'
ITEM.Price = 10000
ITEM.Model = 'models/weapons/w_c4_planted.mdl'
ITEM.WeaponClass = 'keypad_cracker'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end