ITEM.Name = 'M16A4 ACOG'
ITEM.Price = 32000
ITEM.Model = 'models/weapons/w_dmg_m16ag.mdl'
ITEM.WeaponClass = 'm9k_m16a4_acog'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end