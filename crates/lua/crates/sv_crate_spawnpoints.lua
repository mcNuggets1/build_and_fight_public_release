CreateConVar("crate_show_spawns", 0, nil, "Zeigt Admins die Kistenspawns an.")

Crates.SpawnPoints = Crates.SpawnPoints or {}

cvars.AddChangeCallback("crate_show_spawns", function(_, old, new)
	new = tonumber(new)
	if !new then return end
	if (new >= 1) then
		Crates.LoadMapSpawns()
		for _, pos in ipairs(Crates.SpawnPoints) do
			local ent = ents.Create("crate_debug")
			if !IsValid(ent) then return end
			ent:SetPos(pos)
			ent:Spawn()
		end
	elseif (new < 1) then
		for _, ent in ipairs(ents.FindByClass("crate_debug")) do
			ent:Remove()
		end
	end
end)

concommand.Add("crate_add_spawn", function(ply)
	if IsValid(ply) and MG_DeveloperGroups[ply:GetUserGroup()] then
		if GetConVar("crate_show_spawns"):GetBool() then
			Crates.LoadMapSpawns()
			local pos = ply:GetEyeTrace().HitPos or ply:GetPos()
			local ent = ents.Create("crate_debug")
			if !IsValid(ent) then return end
			ent:SetPos(pos)
			ent:Spawn()
			table.insert(Crates.SpawnPoints, pos)
			Crates.SaveMapSpawns()
			ply:PrintMessage(HUD_PRINTTALK, "Möglicher Kistenspawn hinzugefügt!")
		else
			ply:PrintMessage(HUD_PRINTTALK, "Dieser Befehl kann nur benutzt werden, wenn der Konsolenbefehl \"crate_show_spawns\" aktiviert ist!")
		end
	end
end)

concommand.Add("crate_debug", function(ply)
	if IsValid(ply) and MG_DeveloperGroups[ply:GetUserGroup()] then
		if GetConVar("crate_show_spawns"):GetBool() then
			RunConsoleCommand("crate_show_spawns", 0)
			ply:PrintMessage(HUD_PRINTTALK, "Du hast die Sichtbarkeit von Kistenspawns deaktiviert.")
		else
			RunConsoleCommand("crate_show_spawns", 1)
			ply:PrintMessage(HUD_PRINTTALK, "Du hast die Sichtbarkeit von Kistenspawns aktiviert.")

			if !game.IsDedicated() then -- debugoverlay functions only work on hosted games.
				timer.Create("", 3, 0, function()
					for k, v in pairs(ents.FindByClass("crate_debug")) do
						debugoverlay.Sphere(v:GetPos(), 25, 3, Color(255, 0, 0), true)
					end
				end)
			end
		end
	end
end)

concommand.Add("crate_remove_spawn", function(ply)
	if IsValid(ply) and MG_DeveloperGroups[ply:GetUserGroup()] then
		if GetConVar("crate_show_spawns"):GetBool() then
			local spawns = ents.FindInSphere(ply:GetEyeTrace().HitPos, 50)
			if spawns then
				for _, ent in ipairs(spawns) do
					if (ent:GetClass() == "crate_debug") then
						ent:Remove()
						ply:PrintMessage(HUD_PRINTTALK, "Möglicher Kistenspawn entfernt!")

						for k, spawn in ipairs(Crates.SpawnPoints) do -- We actually remove the Spawn point.
							if spawn == ent:GetPos() then
								table.remove(Crates.SpawnPoints, k)
								break
							end
						end

						break
					end
				end
				Crates.SaveMapSpawns()
			end
		else
			ply:PrintMessage(HUD_PRINTTALK, "Dieser Befehl kann nur benutzt werden, wenn der Konsolenbefehl \"crate_show_spawns\" aktiviert ist!")
		end
	end
end)

function Crates.GetSpawn()
	if !Crates.TotalCrateSpawnCount then
		Crates.TotalCrateSpawnCount = #Crates.SpawnPoints
	end
	return Crates.SpawnPoints[math.random(1, Crates.TotalCrateSpawnCount)]
end

function Crates.LoadMapSpawns()
	file.CreateDir("crate_spawns")
	local map = string.lower(game.GetMap())
	if !file.Exists("crate_spawns/"..map..".txt", "DATA") then return end
	Crates.SpawnPoints = util.JSONToTable(file.Read("crate_spawns/"..map..".txt"))
end

function Crates.SaveMapSpawns()
	local map = string.lower(game.GetMap())
	file.Write("crate_spawns/"..map..".txt", util.TableToJSON(Crates.SpawnPoints))
end

hook.Add("InitPostEntity", "Crates.Initialize", Crates.LoadMapSpawns)