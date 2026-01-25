ITEM.Name = 'Rainbow Pistol'
ITEM.Price = 140000
ITEM.Model = 'models/weapons/w_357.mdl'
ITEM.WeaponClass = 'weapon_rainbowpistol'
ITEM.SingleUse = false

function ITEM:OnEquip(ply)
	PS_GiveWeapon(ply, self.WeaponClass, "rainbow", 2)
end

function ITEM:OnHolster(ply)
	PS_StripWeapon(ply, self.WeaponClass, "rainbow", 2)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	model:SetMaterial("models/worldcraft/axis_helper/axis_helper")
	return model, pos, ang
end