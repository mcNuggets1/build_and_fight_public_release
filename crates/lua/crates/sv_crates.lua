function Crates.CrateTimer()
	timer.Simple(math.random(Crates.SpawnMinDelay, Crates.SpawnMaxDelay), function()
		Crates.SpawnCrate()
		Crates.CrateTimer()
	end)
end
hook.Add("InitPostEntity", "Crates.SpawnTimer", Crates.CrateTimer)

local CrateSpawnedTime = 0
local CrateType = ""
function Crates.SpawnCrate()
	Crates.LoadMapSpawns()
	local spawn = Crates.GetSpawn()
	if spawn then
		local crate = ents.Create("crate_usable")
		if !IsValid(crate) then return end
		crate:SetPos(spawn + Vector(0, 0, 10))
		crate.CrateType = math.random(0, 1) == 0 and "Builder" or "Fighter"
		crate:Spawn()
		CrateSpawnedTime = CurTime()
		CrateType = crate.CrateType
		hook.Run("OnCrateSpawned", crate)
	end
end

hook.Add("OnPlayerJoinedBuilder", "Crates.PreventAbuse", function(ply)
	if CrateSpawnedTime + 120 > CurTime() and CrateType == "Builder" then
		ply.Crates_PreventTime = CurTime() + 120
	end
end)

hook.Add("OnPlayerJoinedFighter", "Crates.PreventAbuse", function(ply)
	if CrateSpawnedTime + 120 > CurTime() and CrateType == "Fighter" then
		ply.Crates_PreventTime = CurTime() + 120
	end
end)

util.AddNetworkString("Crates.Uncrate")
function Crates.SendCrateTime(ply, starttime, endtime)
	net.Start("Crates.Uncrate")
		net.WriteFloat(starttime)
		net.WriteFloat(endtime)
	net.Send(ply)
end

util.AddNetworkString("Crates.UncrateResult")
function Crates.SendCrateResult(ply, res)
	net.Start("Crates.UncrateResult")
		net.WriteInt(res, 4)
	net.Send(ply)
end

function Crates.HandlePlayerOpening(ply, crate)
	if !ply:Alive() then return end
	local typ = crate.CrateType
	if typ == "Builder" and !ply:IsBuilder() then ply:ChatPrint("Diese Kiste kann nur von einem Builder geöffnet werden!") return end
	if typ == "Fighter" and !ply:IsFighter() then ply:ChatPrint("Diese Kiste kann nur von einem Fighter geöffnet werden!") return end
	if (ply.Crates_PreventTime or 0) >= CurTime() then
		local time = math.ceil(ply.Crates_PreventTime - CurTime())
		ply:ChatPrint("Du hast gerade deine Klasse geändert!\nÖffnung erst in "..(time == 1 and "1 Sekunde" or time.." Sekunden").." erlaubt.")
		return
	end
	local timername = "Crates.Uncrate_"..ply:EntIndex()
	if timer.Exists(timername) then return end
	ply:Freeze(true)
	local endtime = Crates.UncratingTime
	Crates.SendCrateTime(ply, CurTime(), CurTime() + endtime)
	crate:CallOnRemove("StopUncrating"..ply:EntIndex(), function()
		if !IsValid(ply) or !timer.Exists(timername) then return end
		timer.Remove(timername)
		ply:Freeze(false)
		Crates.HandleUncrating(ply)
	end)
	timer.Create(timername, endtime, 1, function()
		if !IsValid(ply) then return end
		ply:Freeze(false)
		Crates.HandleUncrating(ply, crate)
	end)
end

function Crates.HandleUncrating(ply, crate)
	if !ply:Alive() or !IsValid(crate) then
		Crates.SendCrateResult(ply, 2)
	else
		Crates.SendCrateResult(ply, 1)
		Crates.GiveBonuses(ply)
		SafeRemoveEntity(crate)
		ply:EmitSound("crates/party_blower0"..math.random(1, 2)..".wav")
		local edata = EffectData()
		edata:SetOrigin(ply:GetPos())
		util.Effect("party_effect", edata)
		hook.Run("OnPlayerUncratedCrate", ply)
	end
end

hook.Add("PlayerDeath", "Crates.RemoveTimer", function(ply)
	timer.Remove("Crates.Uncrate_"..ply:EntIndex())
end)