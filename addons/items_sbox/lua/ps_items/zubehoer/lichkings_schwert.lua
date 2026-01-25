ITEM.Name = 'Lichkings Schwert'
ITEM.Price = 25000
ITEM.Model = 'models/maxxy/lich_king_enhanced/arthas_sword.mdl'
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
	local Size = Vector(0.5, 0.5, 0.5)
	local mat = Matrix()
	mat:Scale(Size)
	model:EnableMatrix('RenderMultiply', mat)

	local MAngle = Angle(0, 90, 270)
	local MPos = Vector(9.5, -5.5, 22)

	pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
	ang:RotateAroundAxis(ang:Forward(), MAngle.p)
	ang:RotateAroundAxis(ang:Up(), MAngle.y)
	ang:RotateAroundAxis(ang:Right(), MAngle.r)

	return model, pos, ang
end