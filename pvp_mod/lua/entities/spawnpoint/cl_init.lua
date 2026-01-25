include("shared.lua")

surface.CreateFont("Spawnpoint_Font_Draw", {font = system.IsWindows() and "Tahoma" or "Verdana", size = 50, weight = 600, blursize = 0, scanlines = 0, antialias = true})

function ENT:Draw()
end

local local_ply, distance
local color = Color(200, 100, 100)
function ENT:DrawTranslucent()
	self:DrawModel()
	local_ply = local_ply or LocalPlayer()
	distance = local_ply:EyePos():DistToSqr(self:GetPos())
	if distance > 1000000 then return end
	local text = "Spawnpoint"
	local font = "Spawnpoint_Font_Draw"
	local camangle = Angle(0, local_ply:EyeAngles().y - 90, 90)
	cam.Start3D2D(self:GetPos() + Vector(0, 0, 25), camangle, 0.1)
		draw.SimpleTextOutlined(text, font, 0, 0, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	cam.End3D2D()
end

local use_font = system.IsWindows() and "Tahoma" or "Verdana"
surface.CreateFont("Spawnpoint_Font", {font = use_font, size = 20, weight = 1000, blursize = 0, scanlines = 0, antialias = true})
surface.CreateFont("Spawnpoint_Font2", {font = use_font, size = 13, weight = 1000, blursize = 0, scanlines = 0, antialias = true})
surface.CreateFont("Spawnpoint_Font3", {font = use_font, size = 18, weight = 1000, blursize = 0, scanlines = 0, antialias = true})

local function AddButton(frame)
	frame:SetTall(frame:GetTall() + 45)
	local Button = vgui.Create("DButton", frame)
	Button:SetPos(frame:GetWide() / 2 - 91, frame:GetTall() - 50)
	Button:SetSize(182, 40)
	Button:SetFont("Spawnpoint_Font3")
	Button:SetTextColor(Color(255, 255, 255, 255))
	Button.Paint = function(self, w, h)
		local col
		if self:IsHovered() then
			col = Color(36, 190, 255)
		else
			col = Color(26, 160, 212)
		end
		draw.RoundedBox(0, 0, 0, w, h, Color(22, 131, 173))
		draw.RoundedBox(0, 1, 1, w - 2, h - 2, col)
		surface.SetDrawColor(Color(31, 191, 255, 255))
		surface.DrawLine(1, 1, w - 1, 1)
		surface.DrawLine(1, 1, 1, 40)
		surface.DrawLine(1, 38, w - 1, 38)
		surface.DrawLine(w - 2, 1, w - 2, 40)
	end
	return Button
end

local menu
net.Receive("Spawnpoint_OpenMenu", function(len, ply)
	local players = net.ReadTable()
	local spawn = net.ReadEntity()
	if IsValid(menu) then return end
	local ply = LocalPlayer()
	menu = vgui.Create("DFrame")
	menu:SetSize(200, 52)
	menu:SetVisible(true)
	menu:ShowCloseButton(false)
	menu:MakePopup()
	menu:ParentToHUD()
	menu.Paint = function(self, w, h)
		if !IsValid(spawn) or spawn:GetPos():DistToSqr(ply:GetPos()) > 40000 then self:Close() return end
		draw.RoundedBox(0, 0, 0, w, h, Color(224, 224, 224, 255))
		draw.RoundedBox(0, 1, 1, w - 2, h - 2, Color(250, 250, 250, 255))
		draw.RoundedBox(0, 0, 0, w, 36, Color(62, 67, 77))
		draw.SimpleText("Spawnpoint", "Spawnpoint_Font", 10, 7, Color(255, 255, 255, 255))
		surface.SetDrawColor(Color(84, 89, 100, 255))
		surface.DrawLine(1, 1, w - 1, 1)
		surface.DrawLine(1, 1, 1, 34)
		surface.DrawLine(1, 34, w - 1, 34)
		surface.DrawLine(w - 1, 1, w - 1, 34)
	end
	menu:SetTitle("")
	local close = vgui.Create("DButton", menu)
	close:SetSize(50, 20)
	close:SetPos(menu:GetWide() - 50, 0)
	close:SetText("X")
	close:SetFont("Spawnpoint_Font2")
	close:SetTextColor(Color(255, 255, 255, 255))
	close.Paint = function(self, w, h)
		local col
		if self:IsHovered() then
			col = Color(255, 150, 150, 255)
		else
			col = Color(175, 100, 100)
		end
		draw.RoundedBoxEx(0, 0, 0, w, h, Color(255, 150, 150, 255), false, false, true, true)
		draw.RoundedBoxEx(0, 1, 0, w - 2, h - 1, col, false, false, true, true)
	end
	close.DoClick = function()
		menu:Close()
	end
	if !players[ply] then
		local addself = AddButton(menu)
		addself:SetText("Anmelden")
		addself.DoClick = function()
			net.Start("Spawnpoint_AddPlayer")
				net.WriteEntity(ply)
				net.WriteEntity(spawn)
			net.SendToServer()
			menu:Close()
		end
	else
		local removeself = AddButton(menu)
		removeself:SetText("Abmelden")
		removeself.DoClick = function()
			net.Start("Spawnpoint_RemovePlayer")
				net.WriteEntity(ply)
				net.WriteEntity(spawn)
			net.SendToServer()
			menu:Close()
		end
	end
	local addplayer = AddButton(menu)
	addplayer:SetText("Zugriff gewähren")
	addplayer.DoClick = function()
		local dm = DermaMenu()
		for _,v in ipairs(player.GetAll()) do
			if v != ply and !players[v] then
				dm:AddOption(v:Name(), function()
					net.Start("Spawnpoint_AddPlayer")
						net.WriteEntity(v)
						net.WriteEntity(spawn)
					net.SendToServer()
					players[v] = v
				end)
			end
		end
		dm:Open()
	end
	local removeplayer = AddButton(menu)
	removeplayer:SetText("Zugriff nehmen")
	removeplayer.DoClick = function()
		local dm = DermaMenu()
		for _,v in ipairs(player.GetAll()) do
			if v != ply and players[v] then
				dm:AddOption(v:Name(), function()
					net.Start("Spawnpoint_RemovePlayer")
						net.WriteEntity(v)
						net.WriteEntity(spawn)
					net.SendToServer()
					players[v] = nil
				end)
			end
		end
		dm:Open()
	end
	menu:Center()
end)