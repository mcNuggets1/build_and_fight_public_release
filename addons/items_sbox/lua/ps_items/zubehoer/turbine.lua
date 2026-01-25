ITEM.Name = 'Turbine'
ITEM.Price = 10000
ITEM.Model = 'models/xqm/jetengine.mdl'
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
	local Size = Vector(0.60, 0.60, 0.60)
	local mat = Matrix()
	mat:Scale(Size)
	model:EnableMatrix('RenderMultiply', mat)

	local MAngle = Angle(90, 0, 360)
	local MPos = Vector(11, 10.5, 0)

	pos = pos + (ang:Forward() * MPos.x) + (ang:Up() * MPos.z) + (ang:Right() * MPos.y)
	ang:RotateAroundAxis(ang:Forward(), MAngle.p)
	ang:RotateAroundAxis(ang:Up(), MAngle.y)
	ang:RotateAroundAxis(ang:Right(), MAngle.r)

	return model, pos, ang
end