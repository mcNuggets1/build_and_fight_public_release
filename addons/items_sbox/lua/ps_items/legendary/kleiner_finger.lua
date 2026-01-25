ITEM.Name = 'Gottes kleiner Finger'
ITEM.Price = 130000
ITEM.Model = 'models/maxofs2d/balloon_gman.mdl'
ITEM.WeaponClass = 'weapon_finger'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end