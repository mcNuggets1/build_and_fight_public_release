ITEM.Name = 'Schildgranate'
ITEM.Price = 75000
ITEM.Model = 'models/weapons/w_hexshield_grenade.mdl'
ITEM.WeaponClass = 'weapon_hexgrenade'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end