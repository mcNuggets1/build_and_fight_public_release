ITEM.Name = 'MP9'
ITEM.Price = 27000
ITEM.Model = 'models/weapons/w_brugger_thomet_mp9.mdl'
ITEM.WeaponClass = 'm9k_mp9'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end