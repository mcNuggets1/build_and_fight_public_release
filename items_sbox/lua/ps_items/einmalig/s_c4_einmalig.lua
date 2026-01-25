ITEM.Name = 'Suizidaler Sprengstoff'
ITEM.Price = 3000
ITEM.Model = 'models/weapons/w_sb_planted.mdl'
ITEM.WeaponClass = 'm9k_suicide_bomb'
ITEM.OneUse = true

function ITEM:OnEquip(ply)
	PS_GiveSingleUseWeapon(ply, self.WeaponClass, self.ID)
end