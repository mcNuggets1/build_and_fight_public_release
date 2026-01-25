ITEM.Name = 'Med Kit'
ITEM.Price = 7500
ITEM.Model = 'models/Items/HealthKit.mdl'
ITEM.WeaponClass = 'weapon_medkit'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end