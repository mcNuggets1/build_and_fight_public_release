ITEM.Name = 'M249'
ITEM.Price = 70000
ITEM.Model = 'models/weapons/w_m249_machine_gun.mdl'
ITEM.WeaponClass = 'm9k_m249lmg'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end