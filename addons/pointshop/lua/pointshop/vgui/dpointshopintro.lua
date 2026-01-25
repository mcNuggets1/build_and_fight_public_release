local playintro = CreateClientConVar("shop_playintro", 0, true, false)

local IntroPlayed = false
function PS.IntroShop(parent, open)
	local playintro = playintro:GetInt()
	if playintro >= 3 then return end
	if playintro == 1 and !open then return end
	if playintro == 0 and IntroPlayed then return end
	local Intro = vgui.Create("PS_Intro", parent)
	Intro:SetPos(0, 0)
	Intro:SetSize(parent:GetSize())
	IntroPlayed = PS.Style_Config.ShowIntroOnly1Time
end

local PANEL = {}
function PANEL:Init()
	self.CreatedTime = SysTime()
end

function PANEL:Think()
	if (SysTime() - self.CreatedTime) >= 1.5 then
		self:Remove()
	end
end

function PANEL:Paint(w, h)
	local deltatime = SysTime() - self.CreatedTime
	if deltatime <= 1 then
		draw.RoundedBox(0, 0, 0, w, h, color_black)
		local x, y = w / 2 , h / 2
		draw.SimpleText("Shop", "PS_Treb_S40", x + 230, y - 60, PS.Style_Config.Col.PI.Main_Text, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleText("Modern Gaming", "PS_Treb_TitlePS", x, y, PS.Style_Config.Col.PI.Main_TitleText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	elseif deltatime <= 1.5 then
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, (1.5 - deltatime) * 255 * 2))
	end
end

vgui.Register("PS_Intro", PANEL, "DPanel")