local category = achievements.CreateCategory("Allgemein")
category.Icon = "icon16/world.png"
category.DisplayOrder = 1

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Schreibe 100 Nachrichten in den Chat."
	ACH.Icon = "gui/achievements/talker.png"
	ACH.Target = 100
	ACH.Rewards = {{money = 2000}}

	function ACH:Initialize()
		hook.Add("PlayerSay", "Achv_Talker", function(ply)
			self:AddPoint(ply)
		end)
	end

	achievements.Register(category, "spammer", "Spammer", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Spiele 7 Tage auf dem Server (10.080 Minuten)"
	ACH.Icon = "gui/achievements/playtime.png"
	ACH.Target = 10080
	ACH.Rewards = {{money = 7500}}

	function ACH:Initialize()
		timer.Create("Achv_Addict", 60, 0, function()
			for _, ply in ipairs(player.GetAll()) do
				self:AddPoint(ply)
			end
		end)
	end

	achievements.Register(category, "addict", "Zeitverschwendung", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Spiele eine Stunde alleine auf dem Server."
	ACH.Icon = "gui/achievements/alone.png"
	ACH.Target = 60
	ACH.Rewards = {{money = 2500}}

	function ACH:Initialize()
		timer.Create("Achv_Lonely", 60, 0, function()
			if player.GetCount() == 1 then
				for _, ply in ipairs(player.GetAll()) do
					self:AddPoint(ply)
				end
			end
		end)
	end

	achievements.Register(category, "lonely", "Einsam", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Falle insgesamt 10.000 Meter runter."
	ACH.Icon = "gui/achievements/falling.png"
	ACH.Target = 10000
	ACH.Rewards = {{money = 1000}}
	
	function ACH:Initialize()
		timer.Create("Achv_FlyCheck", 1, 0, function()
			for _, ply in ipairs(player.GetAll()) do
				local is_spec = ply.IsSpec and ply:IsSpec()
				local is_ghost = ply.IsGhost and ply:IsGhost()
				if !ply:Alive() and !is_spec and !is_ghost then continue end
				local ground = ply:OnGround()
				local pos = ply:GetPos()
				local start_z = ply.Achv_StartZ
				local achv_falling = ply.Achv_Falling
				if (!start_z or pos.z > start_z or (ground and !achv_falling)) then
					ply.Achv_StartZ = pos.z
				end
				if !ground and !achv_falling then
					ply.Achv_Falling = true
				elseif ground and achv_falling then
					ply.Achv_Falling = false
					local distance = math.max(0, math.floor((start_z - pos.z) / 12))
					if distance > 5 and distance < 2500 then
						self:AddPoint(ply, distance)
					end
				end
			end
		end)
	end

	achievements.Register(category, "flight", "Guten Flug!", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Laufe insgesamt 500 Meilen."
	ACH.Icon = "gui/achievements/runner.png"
	ACH.Target = 500000
	ACH.Rewards = {{money = 4000}}

	function ACH:Initialize()
		timer.Create("Achv_ThirstyCheck", 1, 0, function()
			for _, ply in ipairs(player.GetAll()) do
				local is_spec = ply.IsSpec and ply:IsSpec()
				local is_ghost = ply.IsGhost and ply:IsGhost()
				if (!ply:Alive() and !is_spec and !is_ghost) or ply:GetMoveType() != MOVETYPE_WALK or !ply:OnGround() then continue end
				local pos = ply:GetPos()
				ply.Achv_LastPlace = ply.Achv_LastPlace or pos
				local distance = ply.Achv_LastPlace:DistToSqr(pos)
				if distance > 0 and distance < 1000000 then
					self:AddPoint(ply, distance / 256)
				end
				ply.Achv_LastPlace = pos
			end
		end)
	end

	achievements.Register(category, "thirsty", "Schweißmauken", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Springe 800 Mal."
	ACH.Icon = "gui/achievements/marioworld.png"
	ACH.Target = 800
	ACH.Rewards = {{money = 4000}}

	function ACH:Initialize()
		hook.Add("KeyPress", "Achv_MarioWorld", function(ply, key)
			if key == IN_JUMP and ply:OnGround() and ply:Alive() and (!ply.Achv_NextJump or CurTime() > ply.Achv_NextJump) then
				ply.Achv_NextJump = CurTime() + 0.1
				self:AddPoint(ply, 1)
			end
		end)
	end

	achievements.Register(category, "marioworld", "Mario World", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Verbringe 10 Minuten Unterwasser."
	ACH.Icon = "gui/achievements/diving.png"
	ACH.Target = 10
	ACH.Rewards = {{money = 5000}}

	function ACH:Initialize()
		timer.Create("Achv_Semiaquatic", 60, 0, function()
			for _, ply in ipairs(player.GetAll()) do
				if ply:Alive() and ply:WaterLevel() >= 3 then
					if ply.IsSpec and ply:IsSpec() then continue end
					if ply.IsGhost and ply:IsGhost() then continue end
					self:AddPoint(ply)
				end
			end
		end)
	end

	achievements.Register(category, "fishy", "Wer braucht schon Kiemen?", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_ONEOFF
	ACH.Description = "Spiele mit 5 Freunden auf dem Server."
	ACH.Icon = "gui/achievements/friends.png"
	ACH.Rewards = {{money = 10000}}

	function ACH:Initialize()
		concommand.Add("achv_givefriendsachv", function(ply)
			self:Complete(ply)
		end)
	end

	if CLIENT then
		local done
		hook.Add("NetworkEntityCreated", "Achv_CheckFriends", function(ply)
			if !ply:IsPlayer() then return end
			local friends = 0
			for _, ply in ipairs(player.GetAll()) do
				if ply:GetFriendStatus() == "friend" then
					friends = friends + 1
				end
			end
			if friends >= 5 and !done then
				RunConsoleCommand("achv_givefriendsachv")
				done = true
			end
		end)
	end

	achievements.Register(category, "bff", "F steht für Freunde...", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_ONEOFF
	ACH.Description = "Spiele auf dem Server, während die Leitung anwesend ist oder schalte alle Errungenschaften frei."
	ACH.Icon = "gui/achievements/death.png"
	ACH.Rewards = {{money = 5000}}

	function ACH:Initialize()
		hook.Add("PlayerInitialSpawn", "Achv_CheckOwner", function()
			timer.Simple(10, function()
				local online = false
				local players = player.GetAll()
				for _, owner in ipairs(players) do
					if MG_OwnerGroups[owner:GetUserGroup()] then
						online = true
						break
					end
				end
				if online then
					for _, v in ipairs(players) do
						self:Complete(v)
					end
				end
			end)
		end)

		hook.Add("achievements_PlayerDataInitialized", "Achv_Owner", function(ply, data, completed)
			ply.Achv_Completed = completed or 0
			if ply.Achv_Completed >= achievements.AchvCount - 2 then
				self:Complete(ply)
			end
		end)
	
		hook.Add("achievements_PlayerDataSet", "Achv_Owner", function(ply, id, data, save)
			if !save then return end
			ply.Achv_Completed = ply.Achv_Completed and ply.Achv_Completed + 1 or 1
			if ply.Achv_Completed >= achievements.AchvCount - 2 then
				self:Complete(ply)
			end
		end)
	end

	achievements.Register(category, "owner", "Keine Autogramme!", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_ONEOFF
	ACH.Description = "Töte einen Administrator."
	ACH.Icon = "gui/achievements/adminkill.png"
	ACH.Rewards = {{money = 0}}

	function ACH:Initialize()
		hook.Add("PlayerDeath", "Achv_AdminKill", function(victim, inflictor, attacker)
			if IsValid(attacker) and attacker:IsPlayer() and attacker != victim and victim:IsAdmin() then
				self:Complete(attacker)
			end
		end)
	end

	achievements.Register(category, "ban", "Bitte bann mich nicht!", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Trete dem Server 100 Mal bei."
	ACH.Icon = "gui/achievements/connect.png"
	ACH.Target = 100
	ACH.Rewards = {{money = 10000}}

	function ACH:Initialize()
		hook.Add("PlayerInitialSpawn", "Achv_Connect", function(ply)
			timer.Simple(3, function()
				if !IsValid(ply) then return end
				self:AddPoint(ply)
			end)
		end)
	end

	achievements.Register(category, "reconnect", "100 Mal", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Töte 100 Spieler mit Kopfschüssen."
	ACH.Icon = "gui/achievements/headshot.png"
	ACH.Target = 100
	ACH.Rewards = {{money = 15000}}

	function ACH:Initialize()
		hook.Add("PlayerDeath", "Achv_Aimbot", function(victim, inflictor, attacker)
			if IsValid(attacker) and attacker:IsPlayer() and victim:LastHitGroup() == HITGROUP_HEAD then
				if attacker == victim then return end
				self:AddPoint(attacker)
			end
		end)
	end

	achievements.Register(category, "aimbot", "Aimbot", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Erreiche 100 Tötungen."
	ACH.Icon = "gui/achievements/gun.png"
	ACH.Target = 100
	ACH.Rewards = {{money = 10000}}

	function ACH:Initialize()
		hook.Add("PlayerDeath", "Achv_Multikill", function(victim, inflictor, attacker)
			if IsValid(attacker) and IsValid(victim) and attacker:IsPlayer() then
				if attacker == victim then return end
				self:AddPoint(attacker)
			end
		end)
	end

	achievements.Register(category, "multikill", "Multikill", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Verteile dein Spray 25 Mal im Server herum."
	ACH.Target = 25
	ACH.Rewards = {{money = 2000}}
	ACH.Icon = "gui/achievements/spray.png"

	function ACH:Initialize()
		hook.Add("PlayerSpray", "Achv_Spray", function(ply)
			self:AddPoint(ply)
		end)
	end

	achievements.Register(category, "spray", "Echter Gangster", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_ONEOFF
	ACH.Description = "Schreibe das \"geheime Wort\" in den Chat."
	ACH.Rewards = {{money = 2000}}
	ACH.Icon = "gui/achievements/secretphrase.png"

	function ACH:Initialize()
		hook.Add("PlayerSay", "Achv_SecretMessage", function(p, text)
			if (string.lower(text) == "geheime wort") then
				self:Complete(p)
			end
		end)
	end

	achievements.Register(category, "secret", "Top Secret!", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_ONEOFF
	ACH.Description = "Schalte alle Errungenschaften frei."
	ACH.Rewards = {{money = 75000}}
	ACH.Icon = "gui/achievements/unlock.png"

	function ACH:Initialize()
		hook.Add("achievements_PlayerDataInitialized", "Achv_100%", function(ply, data, completed)
			ply.Achv_Completed = completed or 0
			local achv = achievements.GetPlayerData(ply, "mainprice")
			if !achv or !achv.Completed then
				ply.Achv_Completed = ply.Achv_Completed + 1
			end
			if ply.Achv_Completed >= achievements.AchvCount - 1 then
				self:Complete(ply)
			end
		end)
	
		hook.Add("achievements_PlayerDataSet", "Achv_100%", function(ply, id, data, save)
			if !save or id == "mainprice" then return end
			ply.Achv_Completed = ply.Achv_Completed and ply.Achv_Completed + 1 or 1
			if ply.Achv_Completed >= achievements.AchvCount - 1 then
				self:Complete(ply)
			end
		end)
	end

	achievements.Register(category, "100%", "100%", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Öffne 3 zufällig spawnende Kisten."
	ACH.Target = 3
	ACH.Rewards = {{money = 4000}}
	ACH.Icon = "gui/achievements/treasure.png"

	function ACH:Initialize()
		hook.Add("OnPlayerUncratedCrate", "Achv_Treasure", function(ply)
			self:AddPoint(ply)
		end)
	end

	achievements.Register(category, "treasure", "Schatzsuche", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_ONEOFF
	ACH.Description = "Stifte einen Unbox."
	ACH.Rewards = {{money = 2500}}
	ACH.Icon = "gui/achievements/unbox.png"

	function ACH:Initialize()
		hook.Add("Unboxing_OnPlayerUnboxedCrate", "Achv_Gift", function(ply, item, gift, giftplayer)
			if gift and IsValid(giftplayer) and (giftplayer != ply) then
				self:Complete(ply)
			end
		end)
	end

	achievements.Register(category, "gift", "Gastfreundschaft", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_ONEOFF
	ACH.Description = "Besitze mindestens 50 verschiedene Items."
	ACH.Rewards = {{money = 25000}}
	ACH.Icon = "gui/achievements/inv.png"

	function ACH:Initialize()
		hook.Add("PS_OnGiveItem", "Achv_FullyEquipped", function(ply)
			if ply.PS_Items then
				local items = table.Count(ply.PS_Items)
				if items <= 50 then return end
				self:Complete(ply)
			end
		end)
	end

	achievements.Register(category, "fullyequipped", "Das Messiesyndrom", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_ONEOFF
	ACH.Description = "Erreiche Prestige 1."
	ACH.Rewards = {{money = 20000}}
	ACH.Icon = "gui/achievements/p1.png"

	function ACH:Initialize()
		hook.Add("Perks_OnPrestige", "Achv_Prestige_1", function(ply, p)
			if p == 1 or p == 2 or p == 3 then
				self:Complete(ply)
			end
		end)
	end

	achievements.Register(category, "p1", "Prestige 1", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_ONEOFF
	ACH.Description = "Erreiche Prestige 2."
	ACH.Rewards = {{money = 30000}}
	ACH.Icon = "gui/achievements/p2.png"

	function ACH:Initialize()
		hook.Add("Perks_OnPrestige", "Achv_Prestige_2", function(ply, p)
			if p == 2 or p == 3 then
				self:Complete(ply)
			end
		end)
	end

	achievements.Register(category, "p2", "Prestige 2", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_ONEOFF
	ACH.Description = "Erreiche Prestige 3."
	ACH.Rewards = {{money = 40000}}
	ACH.Icon = "gui/achievements/p3.png"

	function ACH:Initialize()
		hook.Add("Perks_OnPrestige", "Achv_Prestige_3", function(ply, p)
			if p == 3 then
				self:Complete(ply)
			end
		end)
	end

	achievements.Register(category, "p3", "Prestige 3", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_PROGRESS
	ACH.Description = "Verdiene 250.000 Cash."
	ACH.Icon = "gui/achievements/pspoints.png"
	ACH.Target = 250000
	ACH.Rewards = {{money = 10000}}

	function ACH:Initialize()
		hook.Add("PS_OnGivePoints", "Achv_CashGain", function(ply, points, sender)
			if IsValid(sender) then return end
			self:AddPoint(ply, points)
		end)
	end

	achievements.Register(category, "cash", "Mr. Geldsack", ACH)
end

do
	local ACH = {}
	ACH.Type = ACHIEVEMENT_ONEOFF
	ACH.Description = "Gewinne im Unboxing ein Item von unschätzbarem Wert. (Zählt nicht zur \"100%\"-Errungenschaft dazu)"
	ACH.Icon = "gui/achievements/grandprice.png"
	ACH.Rewards = {{money = 20000}}

	function ACH:Initialize()
		hook.Add("Unboxing_OnPlayerUnboxedCrate", "Achv_MainPrice", function(ply, item, gift, giftplayer)
			if item.Type == "PITEM" then
				local ITEM = PS and PS.Items[item.ItemClassName]
				if ITEM and ITEM.UnboxOnly then
					ply = gift and IsValid(giftplayer) and giftplayer or ply
					self:Complete(ply)
				end
			end
		end)
	end

	achievements.Register(category, "mainprice", "Hauptgewinn", ACH)
end