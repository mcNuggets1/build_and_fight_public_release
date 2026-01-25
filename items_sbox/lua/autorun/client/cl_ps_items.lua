-- Pointshop | Partikeleffekte

local local_ply = NULL
local hideAuras = CreateClientConVar("mg_hideauras", 1, FCVAR_ARCHIVE)
local function PS_HideEffect()
	if !hideAuras:GetBool() then return end

	local i = 0
	local last = local_ply:GetInternalVariable("m_nPrevSequence") -- Particles have a weird behavior. If a Particle is set on the Player m_nPrevSequence will return -1. When this happens, we need to wait for 1 tick
	hook.Add("Tick", "PS_HideAura", function()
		i = i + 1 
		if i < 11 then return end-- We only want to check for Particles for 22 Ticks because in the first 11 ticks the particles won't be received because of the networking delay.
		if i > 33 then -- we remove the Hook after 33 ticks.
			hook.Remove("Tick", "PS_HideAura")
			return
		end
		if !local_ply:IsValid() then return end 

		if last == -1 then
			local_ply:StopParticleEmission()
			hook.Remove("Tick", "PS_HideAura")
			return
		end
		last = local_ply:GetInternalVariable("m_nPrevSequence")
	end)
end

local function PS_CreateParticles()
	local tbl = net.ReadTable()

	local hide = hideAuras:GetBool()
	for ply, v in pairs(tbl) do
		if !IsValid(ply) then continue end
		if local_ply == ply and hide then continue end

		if v.controlpoints <= 1 then
			ParticleEffectAttach(v.particle, v.attachtype, ply, v.attachid)
		else
			local options = {}
			for k=1, v.controlpoints or 64 do
				options[k] = {
					attachtype = v.attachtype,
					entity = ply
				}
			end

			ply:CreateParticleEffect(v.particle, options)
		end
	end
end

local function PS_CreateParticle()
	local ply = net.ReadEntity()
	local tbl = net.ReadTable()
	if !tbl or !IsValid(ply) then return end
	if local_ply == ply and hideAuras:GetBool() then return end

	local options = {}
	for k=1, tbl.controlpoints or 64 do
		options[k] = {
			attachtype = tbl.attachtype,
			entity = ply
		}
	end

	ply:CreateParticleEffect(tbl.particle, options)
end

local PS_ManageFunctions = {
	PS_CreateParticles,
	PS_CreateParticle,
	PS_HideEffect
}
net.Receive("PS_ManageParticles", function()
	local id = net.ReadUInt(2)
	if !id or !PS_ManageFunctions[id] then return end
	local_ply = LocalPlayer()
	if !local_ply:IsValid() then return end
	PS_ManageFunctions[id]()
end)