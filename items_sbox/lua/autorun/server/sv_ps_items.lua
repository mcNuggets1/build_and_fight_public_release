-- Pointshop | Waffen

util.AddNetworkString("PS_ManageParticles")

local unfair = {
	["models/gin_ibushi/oc/rstar/gin_ibushi/gin_ibushi.mdl"] = 1.25,
	["models/datboi/datboi_reference.mdl"] = 1.2,
	["models/player/dewobedil/girls_frontline/hk416/default_p.mdl"] = 1.15,
	["models/polycapn/bill_cipher.mdl"] = 1.15,
	["models/jazzmcfly/brs/brs.mdl"] = 1.15,
	["models/player/e3assassin.mdl"] = 1.1,
	["models/captainbigbutt/vocaloid/luka.mdl"] = 1.1,
	["models/captainbigbutt/vocaloid/miku_classic.mdl"] = 1.1,
	["models/player_sinonsao.mdl"] = 1.1,
	["models/player/charple.mdl"] = 1.05,
	["models/player/skeleton.mdl"] = 1.05
}

local fair = {
	["models/player/hw_link.mdl"] = 0.95,
	["models/player/vanoss/evan.mdl"] = 0.95,
	["models/player/deckboy/storm_trooper_pm.mdl"] = 0.95,
	["models/player/bigsmoke/smoke.mdl"] = 0.9,
	["models/raptor_player/raptor_player.mdl"] = 0.9,
	["models/player/christmas/santa.mdl"] = 0.85,
	["models/player/thomasdankassengine.mdl"] = 0.85,
	["models/player/stanmcg/tvhead/tvhead_playermodel.mdl"] = 0.85,
	["models/player/rick/rick.mdl"] = 0.85,
	["models/player/kermit.mdl"] = 0.85,
	["models/player/lich_king_wow_maskless.mdl"] = 0.75, 
	["models/player/lich_king_wow_masked.mdl"] = 0.75, 
	["models/nseven/the_brain.mdl"] = 0.5,
}

hook.Add("PlayerSpawn", "PS_AllowWeapons", function(ply)
	ply.PS_AllowWeapons = CurTime() + 2.5
end)

hook.Add("EntityTakeDamage", "PS_BalanceItems", function(target, dmg)
	if target:IsPlayer() then
		local model = string.lower(target:GetModel())
		if unfair[model] then
			dmg:ScaleDamage(unfair[model])
		elseif fair[model] then
			dmg:ScaleDamage(fair[model])
		end
		local inflictor = dmg:GetInflictor()
		if IsValid(inflictor) then
			if inflictor:GetClass() == "crossbow_bolt" then
				dmg:ScaleDamage(0.8)
			else
				if inflictor:IsPlayer() then
					local wep = inflictor:GetActiveWeapon()
					if wep:IsValid() then
						local class = wep:GetClass()
						if class == "weapon_smg1" then
							dmg:ScaleDamage(0.75)
						elseif class == "weapon_shotgun" then
							dmg:ScaleDamage(1.4)
						elseif class == "weapon_pistol" then
							dmg:ScaleDamage(1.3)
						elseif class == "weapon_357" then
							dmg:ScaleDamage(0.65)
						end
					end
				end
			end
		end
	end
end)

local max_ammo = {
	["pistol"] = 100,
	["357"] = 60,
	["smg1"] = 300,
	["ar2"] = 300,
	["buckshot"] = 50,
	["lmg"] = 400,
	["sniperpenetratedround"] = 40,
}

hook.Add("PlayerSpawn", "PS_GiveAmmo", function(ply)
	timer.Simple(0, function()
		if !IsValid(ply) or !ply:Alive() or !ply.IsFighter or !ply:IsFighter() then return end
		for k, v in pairs(max_ammo) do
			ply:SetAmmo(v, k)
		end
	end)
end)

function PS_GiveWeapon(ply, weapon, ammo, cnt)
	if ply:Alive() and (!ply.IsFighter or ply:IsFighter()) then
		if (ply.PS_AllowWeapons or 0) > CurTime() then
			ply:Give(weapon)
			if cnt and ammo then
				ply:SetAmmo(cnt, ammo)
			end
		else
			ply:PS_Notify("Shop: Die ausgerüstete Waffe wird erst nach Neuspawnen verfügbar sein!")
		end
	end
end

function PS_StripWeapon(ply, weapon, ammo, cnt)
	if ply:Alive() and (!ply.IsFighter or ply:IsFighter()) then
		weapon = ply:GetWeapon(weapon)
		if weapon:IsValid() then
			weapon:Remove()
		end

		if cnt and ammo then
			ply:SetAmmo(math.max(0, ply:GetAmmoCount(ammo) - cnt), ammo)
		end
	end
end

-- Pointshop | Single Use Waffen

function PS_GiveSingleUseWeapon(ply, weapon, id, ammo, cnt)
	if ply:Alive() and (!ply.IsFighter or ply:IsFighter()) then
		ply:Give(weapon)
		ply:PS_TakeItem(id)
		if cnt and ammo then
			ply:SetAmmo(cnt, ammo)
		end
	end
end

-- Pointshop | PlayerModels

local PlayerModelSizes = {
	["models/player/rick/rick.mdl"] = 1.05,
	["models/player/kermit.mdl"] = 1.05,
	["models/player/alyx.mdl"] = 0.95,
	["models/player/p2_chell.mdl"] = 0.95,
	["models/player/e3assassin.mdl"] = 0.95,
	["models/player/mossman.mdl"] = 0.95,
	["models/player/mossman_arctic.mdl"] = 0.95,
	["models/juliet.mdl"] = 0.95,
	["models/captainbigbutt/vocaloid/luka.mdl"] = 0.95,
	["models/player/police_fem.mdl"] = 0.95,
	["models/captainbigbutt/vocaloid/miku_classic.mdl"] = 0.95,
	["models/player_noire.mdl"] = 0.95,
	["models/player/optimus_prime.mdl"] = 0.9,
	["models/player/zombie_fast.mdl"] = 0.95,
	["models/player/group01/female_01.mdl"] = 0.95,
	["models/player/group01/female_02.mdl"] = 0.95,
	["models/player/group01/female_03.mdl"] = 0.95,
	["models/player/group01/female_04.mdl"] = 0.95,
	["models/player/group01/female_05.mdl"] = 0.95,
	["models/player/group01/female_06.mdl"] = 0.95,
	["models/player/group03/female_01.mdl"] = 0.95,
	["models/player/group03/female_02.mdl"] = 0.95,
	["models/player/group03/female_03.mdl"] = 0.95,
	["models/player/group03/female_04.mdl"] = 0.95,
	["models/player/group03/female_05.mdl"] = 0.95,
	["models/player/group03/female_06.mdl"] = 0.95,
	["models/player/group03m/female_01.mdl"] = 0.95,
	["models/player/group03m/female_02.mdl"] = 0.95,
	["models/player/group03m/female_03.mdl"] = 0.95,
	["models/player/group03m/female_04.mdl"] = 0.95,
	["models/player/group03m/female_05.mdl"] = 0.95,
	["models/player/group03m/female_06.mdl"] = 0.95,
	["models/zed/zed.mdl"] = 0.95,
	["models/player/zombie_classic.mdl"] = 0.95,
	["models/nseven/the_brain.mdl"] = 0.95,
	["models/datboi/datboi_reference.mdl"] = 0.95,
	["models/jazzmcfly/brs/brs.mdl"] = 0.85,
	["models/player_sinonsao.mdl"] = 0.85,
	["models/player/dewobedil/girls_frontline/hk416/default_p.mdl"] = 0.8,
	["models/gin_ibushi/oc/rstar/gin_ibushi/gin_ibushi.mdl"] = 0.75,
}

function PS_GivePlayerModel(ply, model, modifications)
	timer.Simple(0.1, function()
		if IsValid(ply) then
			local sizemod = PlayerModelSizes[string.lower(model)]
			if sizemod and !ply.PS_PlayerSize then
				ply.PS_PlayerSize = sizemod
				ply:SetViewOffset(ply:GetViewOffset() * sizemod)
				ply:SetViewOffsetDucked(ply:GetViewOffset() - Vector(0, 0, 36))
			end
			ply:SetModel(model)
			if modifications then
				local skin = tonumber(modifications.skin)
				if skin then
					ply:SetSkin(skin)
				end
				local bodygroups = modifications.bodygroups
				if bodygroups and istable(bodygroups) then
					for k,v in pairs(bodygroups) do
						if string.find(model, "dod") then
							ply:SetBodygroup(k - 1, v)
						elseif string.find(model, "brs") or string.find(model, "miku_classic") then
							ply:SetBodygroup(k + 1, v)
						elseif string.find(model, "hk416") then
							if k >= 4 then
								ply:SetBodygroup(k + 6, v)
							elseif k == 3 then
								ply:SetBodygroup(k + 4, v)
							else
								ply:SetBodygroup(k + 3, v)
							end
						else
							ply:SetBodygroup(k, v)
						end
					end
				end
			end
			ply:SetupHands()
		end
	end)
end

function PS_RemovePlayerModel(ply)
	timer.Simple(0.1, function()
		if !IsValid(ply) then return end
		local sizemod = ply.PS_PlayerSize
		if sizemod then
			ply:SetViewOffset(ply:GetViewOffset() / sizemod)
			ply:SetViewOffsetDucked(ply:GetViewOffset() - Vector(0, 0, 36))
			ply.PS_PlayerSize = nil
		end
		ply:SetModel("models/player/kleiner.mdl")
		ply:SetupHands()
	end)
end

-- Pointshop | Trails

function PS_GiveTrail(ply, material, modifications)
	if ply:Alive() and !IsValid(ply.PS_Trail) then
		local color = modifications.color
		if color and istable(color) then
			color = Color(tonumber(color.r) or 255, tonumber(color.g) or 255, tonumber(color.b) or 255, tonumber(color.a) or 255)
		else
			color = Color(255, 255, 255)
		end
		ply.PS_Trail = util.SpriteTrail(ply, 0, color, false, 15, 1, 0.6, 0.125, material)
		ply.PS_HasTrail = {["color"] = color, ["material"] = material}
		hook.Run("PS_EquipTrail", ply, ply.PS_Trail)
	end
end

function PS_RemoveTrail(ply)
	if IsValid(ply.PS_Trail) then
		ply.PS_Trail:Remove()
		ply.PS_Trail = nil
	end
end

-- Pointshop | Partikeleffekte 

PS_Particles = PS_Particles or {}

--gameevent.Listen("OnRequestFullUpdate") -- Good for early networking.
--hook.Add("OnRequestFullUpdate", "PS_CreateParticles", function(data) -- Particles get removed when the client requests a full update (cause for a full update could be lags or connection problems).
hook.Add("PlayerInitialSpawn", "PS_CreateParticles", function(ply)
	--local ply = Player(data.userid)
	if !IsValid(ply) then return end

	timer.Simple(10, function() -- delay it because when a particle system is created while the update is received, it will be removed.
		if !IsValid(ply) then return end
		net.Start("PS_ManageParticles")
			net.WriteUInt(1, 2)
			net.WriteTable(PS_Particles)
		net.Send(ply)
	end)
end)

function PS_AttachParticle(ply, particle, attachtype, attachid, controlpoints)
	PS_Particles[ply] = {["particle"] = particle, ["attachtype"] = attachtype, ["attachid"] = attachid, ["controlpoints"] = controlpoints}
	if controlpoints <= 1 then
		ply:StopParticles()
		ParticleEffectAttach(particle, attachtype, ply, attachid)

		net.Start("PS_ManageParticles")
			net.WriteUInt(3, 2)
		net.Send(ply)
	else
		net.Start("PS_ManageParticles")
			net.WriteUInt(2, 2)
			net.WriteEntity(ply)
			net.WriteTable(PS_Particles[ply])
		net.Broadcast()
	end

	hook.Run("PS_EquipParticle", ply)
end

function PS_DetachParticle(ply)
	ply:StopParticles()
	PS_Particles[ply] = nil
end

-- Pointshop | Items verstecken

local blacklist = {
	["Trails"] = true,
	["Auren"] = true,
}

function PS_HideItems(ply, hide)
	for item_id, item in pairs(ply.PS_Items or {}) do
		if item.Equipped then
			local ITEM = PS.Items[item_id]
			if blacklist[ITEM.Category] then
				if hide then
					ITEM:OnHolster(ply, item.Modifiers)
				else
					ITEM:OnEquip(ply, item.Modifiers)
				end
			end
		end
	end
end

local invis_tbl = {}
hook.Add("ULX_OnInvis", "ULX_Invis_Fix", function(ply, invis)
	PS_HideItems(ply, invis)
	if invis then
		invis_tbl[ply] = true
	else
		invis_tbl[ply] = nil
	end
end)

hook.Add("PS_EquipTrail", "ULX_Invis_Fix", function(ply, trail)
	if invis_tbl[ply] then
		trail:SetNoDraw(true)
	end
end)

hook.Add("PS_EquipParticle", "ULX_Invis_Fix", function(ply)
	if invis_tbl[ply] then
		ply:StopParticles()
	end
end)