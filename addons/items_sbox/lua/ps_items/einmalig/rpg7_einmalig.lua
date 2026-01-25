ITEM.Name = 'RPG 7'
ITEM.Price = 4000
ITEM.Model = 'models/weapons/w_GDC_RPG7.mdl'
ITEM.WeaponClass = 'm9k_rpg7'
ITEM.OneUse = true

function ITEM:OnEquip(ply)
	PS_GiveSingleUseWeapon(ply, self.WeaponClass, self.ID, "rpg7_round", 2)
end