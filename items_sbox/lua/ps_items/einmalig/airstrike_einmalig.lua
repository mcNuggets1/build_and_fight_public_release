ITEM.Name = 'Luftschlag'
ITEM.Price = 10000
ITEM.Model = 'models/weapons/binos.mdl'
ITEM.WeaponClass = 'm9k_orbital_strike'
ITEM.OneUse = true

function ITEM:OnEquip(ply)
	PS_GiveSingleUseWeapon(ply, self.WeaponClass, self.ID)
end