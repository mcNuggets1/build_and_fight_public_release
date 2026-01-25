ITEM.Name = 'C4-Sprengstoff'
ITEM.Price = 2500
ITEM.Model = 'models/weapons/w_c4_planted.mdl'
ITEM.WeaponClass = 'm9k_c4'
ITEM.OneUse = true

function ITEM:OnEquip(ply)
	PS_GiveSingleUseWeapon(ply, self.WeaponClass, self.ID)
end