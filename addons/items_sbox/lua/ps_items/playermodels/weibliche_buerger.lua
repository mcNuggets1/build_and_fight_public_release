ITEM.Name = 'Weibliche Bürger'
ITEM.Price = 52000
ITEM.Model = 'models/player/group01/female_01.mdl'
ITEM.PlayerModel = true

local Skins = {
	"models/player/group01/female_01.mdl",
	"models/player/group01/female_02.mdl",
	"models/player/group01/female_03.mdl",
	"models/player/group01/female_04.mdl",
	"models/player/group01/female_05.mdl",
	"models/player/group01/female_06.mdl"
}

function ITEM:OnEquip(ply, modifications)
	PS_GivePlayerModel(ply, Skins[math.random(#Skins)], modifications)
end

function ITEM:OnHolster(ply)
	PS_RemovePlayerModel(ply)
end

local next_frame = 0
local current_model
local current_num = 0
function ITEM:ModifyClientsideModel(ply, model, pos, ang, panel)
	if next_frame <= SysTime() then
		next_frame = SysTime() + 1
		current_num = current_num + 1
		if current_num > #Skins then
			current_num = 1
		end
		current_model = Skins[current_num]
	end
	self.Model = current_model
	local ang = model:GetAngles()
	panel:SetModel(current_model)
	if IsValid(panel:GetEntity()) then
		panel:GetEntity():SetAngles(ang)
	end
	return model, pos, ang
end