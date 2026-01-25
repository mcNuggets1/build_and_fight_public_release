ITEM.Name = 'Entenreifen'
ITEM.Price = 22000
ITEM.Model = 'models/captainbigbutt/skeyler/accessories/duck_tube.mdl'
ITEM.Bone = 'ValveBiped.Bip01_Pelvis'
ITEM.MaxEquip = 1
ITEM.EquipGroup = "Reifen"

function ITEM:OnEquip(ply, modifications)
	if ply:Alive() then
		ply:PS_AddClientsideModel(self.ID)
	end
end

function ITEM:OnHolster(ply)
	ply:PS_RemoveClientsideModel(self.ID)
end

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	local Size = Vector(1.3999999761581, 1.3999999761581, 1.3999999761581)
	local mat = Matrix()
	mat:Scale(Size)
	model:EnableMatrix('RenderMultiply', mat)

	local MAngle = Angle(270, 270, 0)
	local MPos = Vector(0, 1, 0)

	pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
	ang:RotateAroundAxis(ang:Forward(), MAngle.p)
	ang:RotateAroundAxis(ang:Up(), MAngle.y)
	ang:RotateAroundAxis(ang:Right(), MAngle.r)

	return model, pos, ang
end