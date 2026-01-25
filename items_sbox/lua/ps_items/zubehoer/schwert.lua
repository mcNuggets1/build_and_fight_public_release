ITEM.Name = 'Ninjaschwert'
ITEM.Price = 13000
ITEM.Model = 'models/weapons/w_damascus_sword.mdl'
ITEM.Bone = 'ValveBiped.Bip01_Spine2'
ITEM.MaxEquip = 1
ITEM.EquipGroup = "Rücken"

function ITEM:OnEquip(ply, modifications)
	if ply:Alive() then
		ply:PS_AddClientsideModel(self.ID)
	end
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	local MAngle = Angle(180, 355, 233)
	local MPos = Vector(-7, 6, -8)

	pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
	ang:RotateAroundAxis(ang:Forward(), MAngle.p)
	ang:RotateAroundAxis(ang:Up(), MAngle.y)
	ang:RotateAroundAxis(ang:Right(), MAngle.r)

	return model, pos, ang
end