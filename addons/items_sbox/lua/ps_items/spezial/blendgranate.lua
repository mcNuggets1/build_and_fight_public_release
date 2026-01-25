ITEM.Name = 'Blendgranate'
ITEM.Price = 50000
ITEM.Model = 'models/weapons/w_eq_flashbang.mdl'
ITEM.WeaponClass = 'm9k_flash_grenade'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass, "flash_grenade", 1)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end