local category = achievements.CreateCategory("Build & Fight")
category.Icon = "gui/achievements/cat_baf.png"
category.DisplayOrder = 2

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_ONEOFF
	ACH.Description = "Beleidige die Mutter eines Spielers."
	ACH.Rewards = {{money = 0}}
	ACH.Icon = "gui/achievements/banhammer.png"

	function ACH:Initialize()
		hook.Add("PlayerSay", "Achv_Rules", function(ply, text)
			if string.find(text:lower(), "hurensohn") and player.GetCount() > 1 then
				ply:Kill()
				self:Complete(ply)
			end
		end)
	end

	achievements.Register(category, "rules", "Wie bitte?", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Sterbe als Fighter 50 Mal durch Stürze."
	ACH.Target = 50
	ACH.Rewards = {{money = 6000}}
	ACH.Icon = "gui/achievements/falldamage.png"

	function ACH:Initialize()
		hook.Add("PlayerDeath", "Achv_Bonebreaker", function(ply, inf)
			if ply:IsPlayer() and ply:IsFighter() and inf:GetClass() == "worldspawn" then
				self:AddPoint(ply)
			end
		end)
	end

	achievements.Register(category, "bonebreaker", "Hals und Beinbruch", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Töte 30 NPCs."
	ACH.Target = 30
	ACH.Rewards = {{money = 8000}}
	ACH.Icon = "gui/achievements/blood.png"

	function ACH:Initialize()
		hook.Add("OnNPCKilled", "Achv_VirtualHate", function(npc, attacker, inflictor)
			if IsValid(attacker) and attacker:IsPlayer() and npc:IsNPC() then
				self:AddPoint(attacker)
			end
		end)
	end

	achievements.Register(category, "hate", "Virtueller Hass", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Erreiche 1.000 Tötungen als Fighter."
	ACH.Target = 1000
	ACH.Rewards = {{money = 10000}}
	ACH.Icon = "gui/achievements/ninja.png"

	function ACH:Initialize()
		hook.Add("PlayerDeath", "Achv_SuicideHotline", function(victim, inflictor, attacker)
			if IsValid(attacker) and attacker:IsPlayer() and attacker:IsFighter() then
				self:AddPoint(attacker)
			end
		end)
	end

	achievements.Register(category, "hotline", "Serienmörder", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Spawne 500 Props."
	ACH.Target = 500
	ACH.Rewards = {{money = 10000}}
	ACH.Icon = "gui/achievements/propspam.png"

	function ACH:Initialize()
		hook.Add("PlayerSpawnedProp", "Achv_Builder", function(ply, model)
			if (ply.Achv_LastProp or 0) > CurTime() then return end
			ply.Achv_LastProp = CurTime() + 1
			self:AddPoint(ply)
		end)
	end

	achievements.Register(category, "builder", "Baumeister", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Zerstöre insgesamt 40 Props."
	ACH.Target = 40
	ACH.Rewards = {{money = 6000}}
	ACH.Icon = "gui/achievements/explosion.png"

	function ACH:Initialize()
		hook.Add("PropBreak", "Achv_Destruction", function(ply, prop)
			if IsValid(ply) and ply:IsPlayer() then
				self:AddPoint(ply)
			end
		end)
	end

	achievements.Register(category, "destuction", "Aggressionstherapie", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Benutze die Tool Gun 1.000 Mal."
	ACH.Target = 1000
	ACH.Rewards = {{money = 10000}}
	ACH.Icon = "gui/achievements/toolgun.png"

	function ACH:Initialize()
		hook.Add("CanTool", "Achv_Toolgun", function(ply)
			if (ply.Achv_LastTool or 0) > CurTime() then return end
			ply.Achv_LastTool = CurTime() + 0.25
			self:AddPoint(ply)
		end)
	end

	achievements.Register(category, "toolgun", "Werkzeugerprobt", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Sterbe 30 Mal durch deine eigene Dummheit."
	ACH.Target = 30
	ACH.Rewards = {{money = 1000}}
	ACH.Icon = "gui/achievements/skull.png"

	function ACH:Initialize()
		hook.Add("PlayerDeath", "Achv_Suicide", function(victim, inflictor, killer)
			if IsValid(killer) and killer:IsPlayer() and victim == killer then
				self:AddPoint(victim)
			end
		end)
	end

	achievements.Register(category, "suizid", "Suizid-Kult", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Schalte deine Taschenlampe 100 Mal an/aus."
	ACH.Target = 100
	ACH.Rewards = {{money = 2500}}
	ACH.Icon = "gui/achievements/flame.png"

	function ACH:Initialize()
		hook.Add("PlayerSwitchFlashlight", "Achv_EmptyBatteries", function(ply)
			self:AddPoint(ply)
		end)
	end

	achievements.Register(category, "empty", "Leistungsstarke Batterien", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Schalte NoClip 1.000 Mal um."
	ACH.Target = 1000
	ACH.Rewards = {{money = 8000}}
	ACH.Icon = "gui/achievements/jumping.png"

	function ACH:Initialize()
		hook.Add("PlayerNoClip", "Achv_NoClip", function(ply)
			self:AddPoint(ply)
		end, HOOK_MONITOR_LOW or 2)
	end

	achievements.Register(category, "noclip", "I believe I can fly!", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_ONEOFF
	ACH.Description = "Werde zu einer Melone."
	ACH.Rewards = {{money = 2500}}
	ACH.Icon = "gui/achievements/melon.png"

	function ACH:Initialize()
		hook.Add("OnPlayerMelonized", "Achv_Melon", function(ply, mdl)
			if string.lower(mdl) == "models/props_junk/watermelon01.mdl" then
				self:Complete(ply)
			end
		end)
	end

	achievements.Register(category, "melon", "Gestaltenwandler", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_ONEOFF
	ACH.Description = "Setze dich irgendwo hin."
	ACH.Rewards = {{money = 1000}}
	ACH.Icon = "gui/achievements/sitting.png"

	function ACH:Initialize()
		hook.Add("onPlayerSitDown", "Achv_SitDown", function(ply)
			self:Complete(ply)
		end)
	end

	achievements.Register(category, "sitdown", "Eine kleine Pause", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_ONEOFF
	ACH.Description = "Kaufe eine legendäre Waffe."
	ACH.Rewards = {{money = 5000}}
	ACH.Icon = "gui/achievements/legend.png"

	function ACH:Initialize()
		hook.Add("PS_OnBuyItem", "Achv_Legend", function(ply, item_id)
			local ITEM = PS.Items[item_id]
			if ITEM and ITEM.Category == "Legendäre Waffen" then
				self:Complete(ply)
			end
		end)
	end

	achievements.Register(category, "legend", "Legende", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Erreiche 2.500 Tötungen als Fighter."
	ACH.Target = 2500
	ACH.Rewards = {{money = 25000}}
	ACH.Icon = "gui/achievements/2500kills.png"

	function ACH:Initialize()
		hook.Add("PlayerDeath", "Achv_Killer", function(victim, inflictor, attacker)
			if IsValid(attacker) and attacker:IsPlayer() and attacker:IsFighter() then
				self:AddPoint(attacker)
			end
		end)
	end

	achievements.Register(category, "killer", "Serienmörder #2", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Spawne 1.500 Props."
	ACH.Target = 1500
	ACH.Rewards = {{money = 25000}}
	ACH.Icon = "gui/achievements/architect.png"

	function ACH:Initialize()
		hook.Add("PlayerSpawnedProp", "Achv_Architect", function(ply, model)
			if (ply.Achv_LastProp2 or 0) > CurTime() then return end
			ply.Achv_LastProp2 = CurTime() + 1
			self:AddPoint(ply)
		end)
	end

	achievements.Register(category, "architect", "Baumeister #2", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Halte 20 traumhafte Erlebnisse mit der Kamera fest."
	ACH.Target = 20
	ACH.Rewards = {{money = 2500}}
	ACH.Icon = "gui/achievements/photographer.png"

	function ACH:Initialize()
		local weapon = weapons.GetStored

		local cam = weapon("gmod_camera")
		local oldPrimaryAttack = cam.PrimaryAttack
		cam.PrimaryAttack = function(slf)
			oldPrimaryAttack(slf)
			local ply = slf.Owner
			if ply:IsPlayer() and (ply.Achv_NextPhoto or 0) <= CurTime() then
				ply.Achv_NextPhoto = CurTime() + 10
				self:AddPoint(slf.Owner)
			end
		end
	end

	achievements.Register(category, "cam", "Fotograf", ACH)
end