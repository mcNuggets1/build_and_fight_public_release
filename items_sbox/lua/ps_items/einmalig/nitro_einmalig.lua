ITEM.Name = 'Nitro Glycerine'
ITEM.Price = 1500
ITEM.Model = 'models/weapons/w_nitro.mdl'
ITEM.WeaponClass = 'm9k_nitro'
ITEM.OneUse = true

function ITEM:OnEquip(ply)
	PS_GiveSingleUseWeapon(ply, self.WeaponClass, self.ID)
end