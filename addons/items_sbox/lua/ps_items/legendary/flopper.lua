ITEM.Name = 'Flopper Perk'
ITEM.Price = 50000
ITEM.Model = 'models/props_junk/glassbottle01a.mdl'
ITEM.WeaponClass = 'weapon_flopper'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass)
	ply:SelectWeapon("weapon_flooper")
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass)
end