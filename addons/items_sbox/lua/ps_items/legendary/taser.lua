ITEM.Name = 'Taser'
ITEM.Price = 180000
ITEM.Model = 'models/weapons/w_pistol.mdl'
ITEM.WeaponClass = 'weapon_taser'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end