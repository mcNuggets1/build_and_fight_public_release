ITEM.Name = 'Nervengas'
ITEM.Price = 800
ITEM.Model = 'models/healthvial.mdl'
ITEM.WeaponClass = 'm9k_nerve_gas'
ITEM.OneUse = true

function ITEM:OnEquip(ply)
	PS_GiveSingleUseWeapon(ply, self.WeaponClass, self.ID)
end