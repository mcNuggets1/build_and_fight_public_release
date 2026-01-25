ITEM.Name = 'SMG1 [Half-Life 2]'
ITEM.Price = 75000
ITEM.Model = 'models/weapons/w_smg1.mdl'
ITEM.WeaponClass = 'weapon_smg1'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass, "smg1_grenade", 1)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass, "smg1_grenade", 1)
end