net.Receive("Melonize_SendMessage", function()
	local str = net.ReadString()
	local num = net.ReadUInt(16)
	local len = net.ReadUInt(16)
	notification.AddLegacy(str, num, len)
	print(str)
end)

local function GetBind(name)
	local key = input.LookupBinding(name):upper()
	if key == "CTRL" then
		key = "STRG"
	end

	return key
end

local color_normal = Color(200, 255, 150)
local color_highlight = Color(75, 225, 0)
net.Receive("Melonize_OnMelonized", function()
	chat.AddText(color_normal, "Drücke ", color_highlight, GetBind("duck"), color_normal, ", um das Propformat zu verlassen.")
	chat.AddText(color_normal, "Drücke ", color_highlight, GetBind("jump"), color_normal, ", um in die Höhe zu springen.")
end)

local function GrabPlyInfo(ply)
	return (ply.Name and ply:Name() or "Unknown"), (ply.Team and team.GetColor(ply:Team()) or color_white), "ChatFont"
end

local ply, ent
local function DrawPlayerNames()
	ply = ply or LocalPlayer()
	ent = ply:GetEyeTrace().Entity
	if ent.IsValid and ent:IsValid() then
		local ply2 = ent:GetNW2Entity("MelonizePlayer")
		if ply2.IsValid and ply2:IsValid() and ply != ply2 then
			local pos = ent:GetPos():ToScreen()
			local nick, nickclr, font = GrabPlyInfo(ply2)
			draw.DrawText(nick, font, pos.x, pos.y - 30, nickclr, 1)
			local hp = ent:Health()
			if hp > 0 then
				draw.DrawText(math.ceil(hp).." HP", "ChatFont", pos.x, pos.y - 10, nickclr, 1)
			end
		end
	end
end
hook.Add("HUDPaint", "Melonize_DrawPlayerNames", DrawPlayerNames)