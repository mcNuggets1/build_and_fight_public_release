ITEM.Name = 'Riot Schild'
ITEM.Price = 220000
ITEM.Model = 'models/bshields/rshield.mdl'
ITEM.WeaponClass = 'weapon_riot_shield'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end