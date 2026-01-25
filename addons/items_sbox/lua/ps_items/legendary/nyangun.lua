ITEM.Name = 'Nyan Gun'
ITEM.Price = 170000
ITEM.Model = 'models/pwb/weapons/w_uzi.mdl'
ITEM.WeaponClass = 'weapon_nyangun'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end