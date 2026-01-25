melonize = melonize or {}
melonize.ply = melonize.ply or {}
melonize.speed = 100

util.AddNetworkString("Melonize_OnMelonized")
util.AddNetworkString("Melonize_SendMessage")

function melonize.SendMessage(ply, str, num, len)
	net.Start("Melonize_SendMessage")
		net.WriteString(str)
		net.WriteUInt(num or 1, 16)
		net.WriteUInt(len or 5, 16)
	net.Send(ply)
end

function melonize.SetupPlayer(ply)
	melonize.ply[ply:SteamID()] = {}
	local p = melonize.ply[ply:SteamID()]
	p.ply = ply
end

function melonize.melonize(ply, mdl)
	if melonize.IsMelon(ply) then melonize.unmelonize(ply) return end
	if ply.jail then melonize.SendMessage(ply, "Du bist eingesperrt!") return end
	if ply:IsFrozen() then melonize.SendMessage(ply, "Du bist eingefroren!") return end
	if ply:Alive() then
		if !ply.IsBuilder or ply:IsBuilder() then
			if FPP and FPP.BlockedModels[mdl] then
				melonize.SendMessage(ply, "Dieses Modell ist geblockt!")
				return
			end
			if !melonize.IsMelon(ply) then
				if PS then
					ply:PS_HolsterItems()
				end
				local melon_str = "models/props_junk/watermelon01.mdl"
				if mdl then
					mdl = tostring(mdl)
					if !util.IsValidModel(mdl) then
						mdl = melon_str
					end
				else
					mdl = melon_str
				end
				ply:ExitVehicle()
				local melon = ents.Create("prop_physics")
				if !IsValid(melon) then return end
				melon:SetPos(ply:GetPos() + Vector(0, 0, 32))
				melon:SetAngles(ply:GetAngles())
				melon:SetModel(mdl)
				melon:Spawn()
				melon:Activate()
				melon:SetCollisionGroup(COLLISION_GROUP_PLAYER)
				local phys = melon:GetPhysicsObject()
				if IsValid(phys) then
					melon:Activate()
					phys:SetVelocity(ply:GetVelocity())
				end
				melon.jumpallowed = CurTime()
				melon:AddCallback("PhysicsCollide", function(ent, data)
					ent.jumped = false
					ent.jumpallowed = CurTime() + 0.5
				end)
				if melon.CPPISetOwner then
					melon:CPPISetOwner(ply)
				end
				melon:SetNW2Entity("MelonizePlayer", ply)
				local p = melonize.ply[ply:SteamID()]
				p.melon = melon
				local eye_ang = ply:EyeAngles()
				local ang = ply:GetAngles()
				ply:StripWeapons()
				ply:Spectate(OBS_MODE_CHASE)
				ply:SpectateEntity(p.melon)
				ply:SetEyeAngles(eye_ang)
				ply:SetAngles(ang)
				ply:SetNW2Entity("MelonizePlayer", melon)
				net.Start("Melonize_OnMelonized")
				net.Send(ply)
				hook.Run("OnPlayerMelonized", ply, mdl)
			end
		else
			melonize.SendMessage(ply, "Du kannst diesen Befehl nur als Builder benutzen!")
		end
	else
		melonize.SendMessage(ply, "Du musst lebendig sein, um diesen Befehl benutzen zu können!")
	end
end

function melonize.setpos(ply, pos)
	local eye_ang = ply:EyeAngles()
	local ang = ply:GetAngles()
	ply:Spawn()
	ply:SetPos(pos)
	ply:SetEyeAngles(eye_ang)
	ply:SetAngles(ang)
end

function melonize.unmelonize(ply)
	if melonize.IsMelon(ply) then
		local p = melonize.ply[ply:SteamID()]
		local pos = p.melon:GetPos() + p.melon:GetUp()
		p.melon:Remove()
		p.melon = nil
		ply:UnSpectate()
		if ply:Alive() then	
			melonize.setpos(ply, pos)
		end
		melonize.SendMessage(ply, "Du bist nicht länger ein Prop!", 0)
	else
		melonize.SendMessage(ply, "Du bist kein Prop!")
	end
	hook.Run("OnPlayerUnmelonized", ply)
end

function melonize.IsMelon(ply)
	ply = melonize.ply[ply:SteamID()]
	if ply != nil then
		return ply.melon != nil
	end
	return false
end

function melonize.GetMelon(ply)
	ply = melonize.ply[ply:SteamID()]
	if ply != nil then
		return ply.melon
	end
	return nil
end

hook.Add("PlayerInitialSpawn", "melonize_PlayerInitialSpawn", function(ply)
	melonize.SetupPlayer(ply)
end)

hook.Add("PlayerDisconnected", "melonize_PlayerDisconnected", function(ply)
	melonize.ply[ply:SteamID()] = nil
end)

--[[hook.Add("AllowPlayerPickup", "melonize_NoPlayerGrab", function(ply, ent)
	local melon = melonize.GetMelon(ply)
	if melon == ent then
		return false
	end
end)]]

hook.Add("PlayerSay", "melonize_Say", function(ply, txt)
	local cmd, args, hasargs
	args = string.Explode(" ", txt)
	for _,v in pairs(args) do
		v = string.lower(v)
	end
	cmd = args[1]
	table.remove(args, 1)
	hasargs = (#args > 0)
	if !string.StartWith(cmd, ".") then return end
	if cmd == ".gm" or cmd == ".getmelons" then
		local found = false
		local found_plys = {}
		for _,v in ipairs(player.GetAll()) do
			if melonize.IsMelon(v) then
				found = true
				table.insert(found_plys, v:Name())
			end
		end
		if !found then ply:PrintMessage(HUD_PRINTTALK, "Niemand ist momentan in Propform.") return "" end
		local foundstring = table.concat(found_plys, ", ")
		ply:PrintMessage(HUD_PRINTTALK, "Spieler in Propform: "..foundstring..".")
		return ""
	elseif cmd == ".melonize" or cmd == ".m" then
		melonize.melonize(ply, hasargs and args[1] or nil)
		return ""
	elseif cmd == ".unmelonize" or cmd == ".um" then
		melonize.unmelonize(ply)
		return ""
	else
		if melonize.IsMelon(ply) then
			if cmd == ".weight" or cmd == ".w" then
				local phys = melonize.GetMelon(ply):GetPhysicsObject()
				if hasargs then
					if IsValid(phys) then
						if tonumber(args[1]) then
							local weight = math.Round(tonumber(args[1]))
							if weight >= 1 then
								if weight <= 101 then
									phys:SetMass(weight)
									ply:PrintMessage(HUD_PRINTTALK, "Gewicht geändert zu: "..weight)
									return ""
								else
									ply:PrintMessage(HUD_PRINTTALK, "Ungültiges Gewicht. Muss kleiner als 100 sein.")
									return ""
								end
							else
								ply:PrintMessage(HUD_PRINTTALK, "Ungültiges Gewicht. Muss größer als 1 sein.")
								return ""
							end
						else
							ply:PrintMessage(HUD_PRINTTALK, "Ungültiges Gewicht. Muss eine Zahl sein.")
							return ""
						end
					end
				else
					if IsValid(phys) then
						ply:PrintMessage(HUD_PRINTTALK, "Dein Gewicht beträgt: "..phys:GetMass().."kg.")
						return ""
					end
				end
			elseif cmd == ".color" or cmd == ".colour" or cmd == ".c" then
				if hasargs then
					if !args[1] or !args[2] or !args[3] or !args[4] then ply:PrintMessage(HUD_PRINTTALK, "Du musst alle 4 Argumente angegeben!") return "" end
					local col = Color(tonumber(args[1]), tonumber(args[2]), tonumber(args[3]), (args[4] == nil) and 255 or tonumber(args[4]))
					if col.a == 255 then
						melonize.GetMelon(ply):SetRenderMode(RENDERMODE_NORMAL)
					else
						melonize.GetMelon(ply):SetRenderMode(RENDERMODE_TRANSALPHA)
					end
					melonize.GetMelon(ply):SetColor(col)
					ply:PrintMessage(HUD_PRINTTALK, "Einfärbung geändert zu: R: "..col.r.." G: "..col.g.." B: "..col.b.." A: "..col.a)
					return ""
				else
					local col = melonize.GetMelon(ply):GetColor()
					ply:PrintMessage(HUD_PRINTTALK, "Deine derzeitige Einfärbung ist: R: "..col.r.." G: "..col.g.." B: "..col.b.." A: "..col.a)
					return ""
				end
			elseif cmd == ".material" or cmd == ".mat" then
				if hasargs then
					melonize.GetMelon(ply):SetMaterial(args[1])
					ply:PrintMessage(HUD_PRINTTALK, "Material geändert zu: "..args[1])
					return ""
				else
					ply:PrintMessage(HUD_PRINTTALK, "Dein Material ist: "..melonize.GetMelon(ply):GetMaterial())
					return ""
				end
			end
		end
	end
end)

local function MelonizeThink()
	for _,v in pairs(melonize.ply) do
		local ply = v.ply
		if ply then
			if melonize.IsMelon(ply) then
				local melon = v.melon
				if !IsValid(melon) then
					v.melon = nil
					local pos = ply:GetPos()
					melonize.setpos(ply, pos)
					--ply:Kill()
				else
					ply:SetPos(melon:GetPos())
					if ply:KeyDown(IN_DUCK) then
						melonize.unmelonize(ply)
						continue
					end
					local phys = melon:GetPhysicsObject()
					if !IsValid(phys) then continue end
					if ply:KeyDown(IN_JUMP) and melon.jumpallowed > CurTime() and !melon.jumped then
						phys:ApplyForceCenter(ply:GetAngles():Up() * melonize.speed * 30)
						melon.jumpallowed = CurTime() + 0.5
						melon.jumped = true
					end
					if ply:KeyDown(IN_FORWARD) then
						phys:ApplyForceCenter(ply:GetAngles():Forward() * melonize.speed)
					end
					if ply:KeyDown(IN_BACK) then
						phys:ApplyForceCenter(ply:GetAngles():Forward() * -1 * melonize.speed)
					end
					if ply:KeyDown(IN_MOVELEFT) then
						phys:ApplyForceCenter(ply:GetAngles():Right() * -1 * melonize.speed)
					end
					if ply:KeyDown(IN_MOVERIGHT) then
						phys:ApplyForceCenter(ply:GetAngles():Right() * melonize.speed)
					end
				end
			end
		end
	end
end
hook.Add("Think", "melonize_Think", MelonizeThink)

hook.Add("CanPlayerSwitchTeam", "melonize_CanPlayerSwitchTeam", function(ply, team)
	if melonize.IsMelon(ply) then
		return false
	end
end)

hook.Add("PostPlayerDeath", "melonize_PostPlayerDeath", function(ply)
	if melonize.IsMelon(ply) then
		melonize.unmelonize(ply)
	end
end)

hook.Add("PlayerUse", "melonize_PlayerUse", function(ply)
	if melonize.IsMelon(ply) then
		return false
	end
end)

hook.Add("CanPlayerSuicide", "melonize_CanPlayerSuicide", function(ply)
	if melonize.IsMelon(ply) then
		return false
	end
end)

hook.Add("PlayerSpawnObject", "melonize_PlayerSpawnObject", function(ply)
	if melonize.IsMelon(ply) then
		return false
	end
end)

hook.Add("PlayerGiveSWEP", "melonize_PlayerGiveSWEP", function(ply)	
	if melonize.IsMelon(ply) then
		return false  
	end
end)

hook.Add("PlayerSwitchWeapon", "melonize_PlayerSwitchWeapon", function(ply, old, new)
	if melonize.IsMelon(ply) then
		return true
	end
end)

hook.Add("PlayerCanPickupWeapon", "melonize_PlayerCanPickupWeapon", function(ply, wep)
	if melonize.IsMelon(ply) then
		return false
	end
end)

hook.Add("ULXPlayerFreeze", "melonize_ULXPlayerFreeze", function(ply)
	if melonize.IsMelon(ply) then
		melonize.unmelonize(ply)
	end
end)

hook.Add("ULXPlayerTeleport", "melonize_ULXPlayerTeleport", function(ply)
	if melonize.IsMelon(ply) then
		melonize.unmelonize(ply)
	end
end)

hook.Add("ULXPlayerJail", "melonize_ULXPlayerJail", function(ply)
	if melonize.IsMelon(ply) then
		melonize.unmelonize(ply)
	end
end)

concommand.Add("melonize", function(ply, cmd, args)
	if !IsValid(ply) then return end
	melonize.melonize(ply)
end)

concommand.Add("unmelonize", function(ply, cmd, args)
	if !IsValid(ply) then return end
	melonize.unmelonize(ply)
end)
