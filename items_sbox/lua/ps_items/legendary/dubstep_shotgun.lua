ITEM.Name = 'Dubstep Shotgun'
ITEM.Price = 250000
ITEM.Model = 'models/weapons/w_shot_bulkcn.mdl'
ITEM.WeaponClass = 'weapon_dubshotgun'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end