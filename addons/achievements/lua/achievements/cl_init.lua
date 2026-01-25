include("shared.lua")
include("cl_networking.lua")
include("vgui/achnotify.lua")
include("vgui/achprogressbar.lua")

function achievements.Award(ply, name, icon)
	if ply == LocalPlayer() then
		local notify = vgui.Create("AchievementsNotify")
		notify:SetAchievement(name, icon)
	end

	if achievements.ShowInChat then
		chat.AddText(Color(100, 100, 255), ply:Name(), Color(150, 150, 150), " hat das Achievement ", Color(255, 102, 102), name, Color(150, 150, 150), " erhalten.")
	end
end

achievements.CurrentView = nil
local function OpenAchievements()
	if !achievements.DataRetrieved then
		surface.PlaySound("buttons/button2.wav")
		notification.AddLegacy("Errungenschaften-Daten noch nicht synchronisiert. Bitte versuche es später erneut!", NOTIFY_ERROR, 4)
		return
	end
	if achievements.CurrentView then
		if IsValid(achievements.CurrentView.ParentFrame) and achievements.CurrentView.ParentFrame:IsVisible() then
			achievements.CurrentView.ParentFrame:Close()
			achievements.CurrentView = nil
			return
		end
	end
	include(achievements.Path.."/skin/"..achievements.Skin..".lua")
	achievements.CurrentView = VIEW
	VIEW = nil
	achievements.CurrentView:Init({
		WindowTitle = achievements.FrameTitle or "Errungenschaften"
	})
	local categories = table.ClearKeys(table.Copy(achievements.GetCategories()))
	table.SortByMember(categories, "DisplayOrder", true)
	for k, v in ipairs(categories) do
		local own = 0
		local total = 0
		for _, ach in pairs(v.Achievements) do
			local ply_data = achievements.LocalData[ach] or {}
			own = ply_data.Completed and (own + 1) or own
			total = total + 1
		end
		achievements.CurrentView:AddCategory(v.Name, v.Icon, own, total)
	end
	for _, v in ipairs(categories) do
		local incompleteAchievements = {}
		local completedAchievements = {}
		for _, v2 in pairs(v.Achievements) do
			local data = table.Copy(achievements.GetAchievement(v2))
			local ply_data = achievements.GetPlayerData(data.ID)
			table.Merge(data, ply_data)
			data.Category = v.Name
			table.insert(data.Completed and completedAchievements or incompleteAchievements, data)
		end
		table.SortByMember(incompleteAchievements, "Name", true)
		table.SortByMember(completedAchievements, "Name", true)
		table.sort(incompleteAchievements, function(a, b)
			return achievements.CurrentView:IsAchievementMarked(a) and not achievements.CurrentView:IsAchievementMarked(b)
		end)
		table.sort(completedAchievements, function(a, b)
			return achievements.CurrentView:IsAchievementMarked(a) and not achievements.CurrentView:IsAchievementMarked(b)
		end)

		for _, data in ipairs(incompleteAchievements) do
			achievements.CurrentView:AddAchievement(data)
		end
		for _, data in ipairs(completedAchievements) do
			achievements.CurrentView:AddAchievement(data)
		end
	end
end

if achievements.OpenKey then
	local AchvOpened
	local function AchvThink()
		if input.IsKeyDown(achievements.OpenKey) then
			if AchvOpened then return end
			AchvOpened = true
			OpenAchievements()
		else
			AchvOpened = false
		end
	end
	hook.Add("Think", "Achv_Open", AchvThink)
end

hook.Add("OnPlayerChat", "Achv_Open", function(ply, msg)
	if ply != LocalPlayer() then return end
	if (string.lower(msg) == achievements.ChatCommand) then
		OpenAchievements()
		return true
	end
end)
concommand.Add(achievements.ConsoleCommand, OpenAchievements)