ITEM.Name = 'M79 GL'
ITEM.Price = 4000
ITEM.Model = 'models/weapons/w_m79_grenadelauncher.mdl'
ITEM.WeaponClass = 'm9k_m79gl'
ITEM.OneUse = true

function ITEM:OnEquip(ply)
	PS_GiveSingleUseWeapon(ply, self.WeaponClass, self.ID, "m79_nade", 2)
end