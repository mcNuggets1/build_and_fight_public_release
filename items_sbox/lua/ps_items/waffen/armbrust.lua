ITEM.Name = 'Armbrust [Half-Life 2]'
ITEM.Price = 30000
ITEM.Model = 'models/weapons/c_crossbow.mdl'
ITEM.WeaponClass = 'weapon_crossbow'
ITEM.SingleUse = false

if CLIENT then
	language.Add("XBowBolt_ammo", "Bolzen")
end

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass, "xbowbolt", 10)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass, "xbowbolt", 10)
end