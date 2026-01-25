ITEM.Name = 'USAS'
ITEM.Price = 70000
ITEM.Model = 'models/weapons/w_usas_12.mdl'
ITEM.WeaponClass = 'm9k_usas'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end