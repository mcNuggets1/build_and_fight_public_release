ITEM.Name = 'Handybombe'
ITEM.Price = 1500
ITEM.Model = 'models/weapons/w_camphon2.mdl'
ITEM.WeaponClass = 'm9k_ied_detonator'
ITEM.OneUse = true

function ITEM:OnEquip(ply)
	PS_GiveSingleUseWeapon(ply, self.WeaponClass, self.ID)
end