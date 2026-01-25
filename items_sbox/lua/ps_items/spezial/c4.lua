ITEM.Name = 'C4-Sprengstoff'
ITEM.Price = 100000
ITEM.Model = 'models/weapons/w_c4_planted.mdl'
ITEM.WeaponClass = 'm9k_c4'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end