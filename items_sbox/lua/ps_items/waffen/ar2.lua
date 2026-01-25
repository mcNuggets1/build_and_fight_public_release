ITEM.Name = 'Impulsgewehr (AR2) [Half-Life 2]'
ITEM.Price = 80000
ITEM.Model = 'models/weapons/w_irifle.mdl'
ITEM.WeaponClass = 'weapon_ar2'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass, "ar2altfire", 1)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass, "ar2altfire", 1)
end