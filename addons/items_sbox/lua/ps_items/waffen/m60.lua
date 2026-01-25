ITEM.Name = 'M60'
ITEM.Price = 60000
ITEM.Model = 'models/weapons/w_m60_machine_gun.mdl'
ITEM.WeaponClass = 'm9k_m60'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end