ITEM.Name = 'Konfigurierbarer Text'
ITEM.Price = 300000
ITEM.Model = 'models/extras/info_speech.mdl'
ITEM.NoPreview = true

local PS_TextPlayers = {}
if SERVER then
	util.AddNetworkString("PS_UpdateText")

	hook.Add("PlayerInitialSpawn", "PS_UpdateTexts", function(ply)
		timer.Simple(3, function()
			if !IsValid(ply) then return end
			for k, v in pairs(PS_TextPlayers) do
				if !IsValid(k) then PS_TextPlayers[k] = nil continue end
				if ply == k then continue end
				net.Start("PS_UpdateText")
					net.WriteEntity(k)
					net.WriteString(v.text)
					net.WriteTable(v.color)
				net.Send(ply)
			end
		end)
	end)
end

if CLIENT then
	surface.CreateFont("PS_TextItem", {font = "coolvetica", size = 64})

	net.Receive("PS_UpdateText", function()
		local ply = net.ReadEntity()
		if !IsValid(ply) then return end
		local text = net.ReadString()
		if text == "" then
			PS_TextPlayers[ply] = nil
		else
			local color = net.ReadTable()
			color = Color(tonumber(color.r) or 255, tonumber(color.g) or 255, tonumber(color.b) or 255, tonumber(color.a) or 255)
			PS_TextPlayers[ply] = {["text"] = text, ["color"] = color}
		end
	end)
end

local MaxTextLength = 30
function ITEM:OnEquip(ply, modifications)
	if ply:Alive() then
		if modifications.text and !isstring(modifications.text) then return end
		local text = string.sub(modifications.text or ply:Name(), 1, MaxTextLength)
		local color = modifications.color or Color(255, 255, 255)
		net.Start("PS_UpdateText")
			net.WriteEntity(ply)
			net.WriteString(text)
			net.WriteTable(color)
		net.SendOmit(ply)
		ply.PS_HasText = {["text"] = text, ["color"] = color}
		PS_TextPlayers[ply] = {["text"] = text, ["color"] = color}
	end
end

function ITEM:OnModify(ply, modifications)
	self:OnEquip(ply, modifications)
end

function ITEM:OnHolster(ply)
	net.Start("PS_UpdateText")
		net.WriteEntity(ply)
		net.WriteString("")
	net.SendOmit(ply)
	ply.PS_HasText = nil
	PS_TextPlayers[ply] = nil
end

local function DrawTextscreens()
	local ply = LocalPlayer()
	for k, v in pairs(PS_TextPlayers) do
		if !IsValid(k) then PS_TextPlayers[k] = nil continue end
		if k:IsDormant() or k:GetNoDraw() or !k:Alive() then continue end
		if k.IsSpec and k:IsSpec() or k.IsGhost and k:IsGhost() then continue end
		local modifications = v
		local ang = ply:EyeAngles()
		local pos = k:EyePos() + Vector(0, 0, 26) + ang:Up()
		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), 90)
		cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.1)
			draw.DrawText(modifications.text, "PS_TextItem", 2, 2, modifications.color, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end
hook.Add("PostDrawTranslucentRenderables", "PS_DrawTextscreens", DrawTextscreens)

function ITEM:Modify(modifications)
	PS:ShowSearch("Was möchtest du über deinem Kopf stehen haben?", function(text)
		modifications.text = string.sub(text, 1, MaxTextLength)
		PS:ShowColorChooser(self, modifications)
	end, nil, true)
end