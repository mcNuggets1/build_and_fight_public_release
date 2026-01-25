ITEM.Name = 'Desert Eagle'
ITEM.Price = 15000
ITEM.Model = 'models/weapons/w_tcom_deagle.mdl'
ITEM.WeaponClass = 'm9k_deagle'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end