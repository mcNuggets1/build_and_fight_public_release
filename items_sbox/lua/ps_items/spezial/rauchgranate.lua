ITEM.Name = 'Rauchgranate'
ITEM.Price = 60000
ITEM.Model = 'models/weapons/w_eq_smokegrenade.mdl'
ITEM.WeaponClass = 'm9k_smoke_grenade'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass, "smoke_grenade", 1)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end